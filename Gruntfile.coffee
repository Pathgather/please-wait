module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-compass'

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    compass:
      dist:
        options:
          sassDir: 'src',
          cssDir: 'build'
    meta:
      banner: '/* <%= pkg.name %> - v<%= pkg.version %> - <%= grunt.template.today("yyyy-mm-dd") %> */\n'
    coffeelint:
      src: 'src/**/*.coffee'
      options:
        max_line_length:
          level: 'ignore'
    clean:
      options:
        force: true
      build: ["compile/**", "build/**"]
    coffee:
      compile:
        files: [
          {
            expand: true
            cwd: 'src/'
            src: '**/*.coffee'
            dest: 'compile/'
            ext: '.js'
          }
        ],
        options:
          bare: true
    concat:
      options:
        banner: '<%= meta.banner %>'
      dist:
        src: 'compile/**/*.js'
        dest: 'build/please-wait.js'
    uglify:
      options:
        banner: '<%= meta.banner %>'
      dist:
        src: ['build/please-wait.js']
        dest: 'build/please-wait.min.js'

  grunt.registerTask 'default', ['coffeelint', 'clean', 'compass', 'coffee', 'concat', 'uglify']