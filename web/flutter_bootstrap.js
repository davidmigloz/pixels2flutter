{{flutter_js}}
{{flutter_build_config}}

const loading = document.querySelector('#loading');

_flutter.loader.load({
  serviceWorkerSettings: {
    serviceWorkerVersion: {{flutter_service_worker_version}},
  },
  onEntrypointLoaded: async function(engineInitializer) {
    loading.classList.add('main_done');
    const appRunner = await engineInitializer.initializeEngine();
    loading.classList.add('init_done');
    await appRunner.runApp();
    // Wait a few milliseconds so users can see the "zoooom" animation
    // before getting rid of the "loading" div.
    window.setTimeout(function () {
      loading.remove();
    }, 200);
  },
});
