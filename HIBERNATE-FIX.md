# Гибернация не резюмится — диагностика (2026-08-17)

## Что нашёл в логах

`journalctl` за последние 30 дней: hibernate (`systemctl hibernate` / `PM: hibernation: hibernation entry`)
срабатывал минимум дважды (30 июля, 13 августа). Оба раза следующий boot
проваливал resume:

```
systemd-hibernate-resume[...]: Unable to resume from device
'/dev/disk/by-uuid/f3f670ff-b051-4524-a50d-80cea5349557' (259:2) offset 882688,
continuing boot process.
```

Т.е. образ памяти на swap записывался, но при старте систем не смог его
найти/провалидировать и просто продолжал холодный boot — выглядит как
"комп не хочет включаться" (сессия теряется, экран долго висит, приходится
жать питание заново).

Причина: `resume=`/`resume_offset=` не были прописаны в kernel params —
systemd сам пытался вычислить offset свопфайла через generator в initrd,
и это ловило гонку (resume-попытка шла до того как диск/раздел были
до конца готовы). Проверил заодно — zram выключен, Secure Boot выключен,
lockdown не активен, так что это не они.

## Что сделал

- `modules/host/boot.nix`: добавил `boot.resumeDevice` (UUID корня, где
  лежит `/.swapfile`) и `resume_offset=882688` в `kernelParams` — offset и
  UUID взял из тех самых логов systemd-hibernate-resume (он их резолвил
  правильно оба раза, стабильно). Это форсирует явный resume path вместо
  авто-детекта.
- Прогнал `alejandra` (форматирование ок, без изменений) и
  `nix build .#nixosConfigurations.core.config.system.build.toplevel` —
  собирается, в итоговом kernel cmdline видно
  `resume_offset=882688 ... resume=/dev/disk/by-uuid/f3f670ff-...`.
- `deadnix` / `statix` на файл — чисто.

## Что НЕ сделал

- **Не применял** (`just switch` не запускал — по правилам проекта это
  делается только по явной просьбе, плюс сам факт resume нельзя
  протестировать без реальной гибернации на живой машине).
- Не запускал `filefrag /.swapfile` сам (нет sudo в этой сессии) — offset
  882688 взят из journal, не пересчитан заново. Если после `switch`
  resume снова не сработает — пересчитать вручную:
  ```
  sudo filefrag -v /.swapfile | awk '$1=="0:" {print $4}'   # offset в 4K-блоках
  ```
  и поправить `resume_offset` в boot.nix, если число другое.
- Не трогал `amdgpu.aspm=0` — этот параметр уже стоит из-за отдельной
  истории с зависанием на resume из s2idle (suspend, не hibernate),
  не relevant к этой проблеме напрямую, но если после фикса resume
  из hibernate будет виснуть на этапе восстановления GPU — смотреть
  в эту сторону тоже.

## Как проверить после `just switch`

1. `systemctl hibernate` (или через что он у тебя триггерится).
2. Дождаться полного выключения экрана/питания.
3. Включить — должна вернуться сессия, не холодный boot.
4. Если не взлетело — `journalctl -b 0 -g resume -i` на новый boot,
   смотреть тот же паттерн "Unable to resume".
