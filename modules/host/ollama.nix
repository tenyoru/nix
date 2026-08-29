{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    # gfx1103 (Radeon 780M / Phoenix1) isn't officially in ROCm's support
    # matrix; this override tells it to run the gfx1100 codepath instead.
    environmentVariables = {
      HSA_OVERRIDE_GFX_VERSION = "11.0.0";
      # Ollama drops iGPUs by default (shared-memory GPUs are usually slower
      # than CPU); this laptop has no dGPU, so force it on.
      OLLAMA_IGPU_ENABLE = "1";
      # First model load on this iGPU JIT-compiles ROCm kernels and blows
      # past the 5m default, causing a spurious 500 on the first request.
      OLLAMA_LOAD_TIMEOUT = "20m";
    };
  };
}
