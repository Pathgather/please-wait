module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    compass:
      dist:
        options:
          sassDir: 'src',
          cssDir: 'build'
    meta:
      banner: """
        /**
        * <%= pkg.name %>
        * <%= pkg.description %>\n
        * @author <%= pkg.author.name %> <<%= pkg.author.email %>>
        * @copyright <%= pkg.author.name %> <%= grunt.template.today('yyyy') %>
        * @license <%= pkg.licenses[0].type %> <<%= pkg.licenses[0].url %>>
        * @link <%= pkg.homepage %>
        * @module <%= pkg.module %>
        * @version <%= pkg.version %>
        */\n
      """
    coffeelint:
      src: 'src/**/*.coffee'
      options:
        max_line_length:
          level: 'ignore'
    clean:
      dist:
        build: ["compile/**", "build/**"]
      test:
        build: ["compile/**"]
    coffee:
      compile:
        files: [
          expand: true
          cwd: 'src/'
          src: '**/*.coffee'
          dest: 'compile/'
          ext: '.js'
        ],
        options:
          bare: true
      test:
        files: [
          expand: true,
          cwd: 'spec',
          src: '**/*.coffee',
          dest: 'compile/spec',
          ext: '.js'
        ]
    concat:
      options:
        banner: '<%= meta.banner %>'
      dist:
        src: 'compile/please-wait.js'
        dest: 'build/please-wait.js'
    uglify:
      options:
        banner: '<%= meta.banner %>'
      dist:
        src: ['build/please-wait.js']
        dest: 'build/please-wait.min.js'
    jasmine:
      please_wait:
        src: 'compile/**/*.js'
        options:
          specs: 'compile/spec/*.spec.js',
          helpers: 'compile/spec/*.helper.js'

  grunt.registerTask 'default', ['coffeelint', 'clean', 'compass', 'coffee', 'concat', 'uglify']
  grunt.registerTask 'test', [
    'coffeelint',
    'clean:test',
    'coffee',
    'jasmine'
  ]