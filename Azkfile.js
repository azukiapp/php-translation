/**
 * Documentation: http://docs.azk.io/Azkfile.js
 */

// Adds the systems that shape your system
systems({
  'php-translation': {
    // Dependent systems
    depends: [],
    // More images:  http://images.azk.io
    image: "azukiapp/php-translation",
    provision: [
      "./bin/provision",
    ],
    workdir: "/azk/#{manifest.dir}",
    shell: "/bin/bash",
    command: "./bin/run",
    wait: {"retry": 20, "timeout": 1000},
    http: {
      domains: [
        "#{system.name}.#{azk.default_domain}",
      ],
    },
    ports: {
      http: "80/tcp",
    },
    mounts: {
      '/azk/#{manifest.dir}': path(".", { vbox: true }),
      '/azk/mydocs_php': persistent("docs_php"),
    },
    envs: {
      PATH: "/azk/#{manifest.dir}/node_modules/.bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
      SERVER_NAME: "#{system.name}.#{azk.default_domain}",
      HTTP_HOST: "#{system.name}.#{azk.default_domain}",
    },
  },
});

