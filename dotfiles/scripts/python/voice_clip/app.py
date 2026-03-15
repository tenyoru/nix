from __future__ import annotations

import os
import shutil
import signal
import subprocess
import sys
from pathlib import Path

from faster_whisper import WhisperModel


def env(name: str, default: str) -> str:
    value = os.getenv(name)
    return value if value else default


def env_int(name: str, default: int) -> int:
    try:
        return int(env(name, str(default)))
    except ValueError:
        return default


MODEL = env("VOICE_CLIP_MODEL", "tiny")
LANG = env("VOICE_CLIP_LANG", "auto")
TASK = env("VOICE_CLIP_TASK", "transcribe")
INPUT_DEVICE = env("VOICE_CLIP_INPUT", "default")
DEVICE = env("VOICE_CLIP_DEVICE", "cpu")
COMPUTE_TYPE = env("VOICE_CLIP_COMPUTE_TYPE", "int8")
VAD_FILTER = env("VOICE_CLIP_VAD_FILTER", "false").lower() in {"1", "true", "yes", "on"}
BEAM_SIZE = env_int("VOICE_CLIP_BEAM_SIZE", 1)
STATE_DIR = Path(env("XDG_RUNTIME_DIR", "/tmp"))
PID_FILE = STATE_DIR / "voice-clip.pid"
WAV_FILE = STATE_DIR / "voice-clip.wav"


def notify_msg(title: str, body: str) -> None:
    if shutil.which("dunstify"):
        subprocess.run(
            ["dunstify", title, body],
            check=False,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        return
    if shutil.which("notify-desktop"):
        subprocess.run(
            ["notify-desktop", title, body],
            check=False,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        return
    if shutil.which("notify-send"):
        subprocess.run(["notify-send", title, body], check=False)
        return
    print(f"{title}: {body}")


def ensure_dependencies() -> None:
    if not shutil.which("ffmpeg"):
        print("ffmpeg is required", file=sys.stderr)
        raise SystemExit(1)


def process_exists(pid: int) -> bool:
    try:
        os.kill(pid, 0)
    except OSError:
        return False
    return True


def copy_and_print(text: str) -> None:
    if shutil.which("wl-copy"):
        proc = subprocess.run(["wl-copy"], input=text, text=True, check=False)
        if proc.returncode == 0:
            print(f"Copied to clipboard: {text}")
            return
    elif shutil.which("xclip"):
        proc = subprocess.run(
            ["xclip", "-selection", "clipboard"], input=text, text=True, check=False
        )
        if proc.returncode == 0:
            print(f"Copied to clipboard: {text}")
            return
    print("No clipboard tool found (install wl-copy or xclip).", file=sys.stderr)
    raise SystemExit(1)


def transcribe() -> str:
    model = WhisperModel(MODEL, device=DEVICE, compute_type=COMPUTE_TYPE)
    segments, _ = model.transcribe(
        str(WAV_FILE),
        language=None if LANG == "auto" else LANG,
        task=TASK,
        vad_filter=VAD_FILTER,
        beam_size=BEAM_SIZE,
    )
    return (
        " ".join(segment.text.strip() for segment in segments)
        .replace("\n", " ")
        .strip()
    )


def start_recording() -> None:
    WAV_FILE.parent.mkdir(parents=True, exist_ok=True)
    proc = subprocess.Popen(
        [
            "ffmpeg",
            "-loglevel",
            "error",
            "-f",
            "pulse",
            "-i",
            INPUT_DEVICE,
            "-ac",
            "1",
            "-ar",
            "16000",
            "-y",
            str(WAV_FILE),
        ],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    PID_FILE.write_text(f"{proc.pid}\n", encoding="utf-8")
    print("Recording... run voice-clip again to stop.")
    notify_msg("voice-clip", "Recording started")


def stop_recording() -> None:
    try:
        pid = int(PID_FILE.read_text(encoding="utf-8").strip())
    except (ValueError, OSError):
        PID_FILE.unlink(missing_ok=True)
        print("Recording state is invalid, starting a new recording.")
        start_recording()
        return

    try:
        os.kill(pid, signal.SIGINT)
    except OSError:
        pass

    PID_FILE.unlink(missing_ok=True)

    notify_msg("voice-clip", "Transcribing...")
    text = transcribe()

    if not text:
        print("No speech detected.", file=sys.stderr)
        notify_msg("voice-clip", "No speech detected")
        raise SystemExit(1)

    copy_and_print(text)
    notify_msg("voice-clip", "Done: copied to clipboard")


def main() -> None:
    ensure_dependencies()
    if PID_FILE.exists():
        try:
            pid = int(PID_FILE.read_text(encoding="utf-8").strip())
        except (ValueError, OSError):
            pid = -1
        if pid > 0 and process_exists(pid):
            stop_recording()
            return
        PID_FILE.unlink(missing_ok=True)
    start_recording()
