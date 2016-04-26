'use strict'

module.exports = (grunt) ->

  coffeeLintRules = require './coffeelint'
  PATTERN_LOAD_TASK =
    pattern: 'grunt-*'
    scope: 'devDependencies'

  # Load grunt tasks automatically
  (require 'load-grunt-tasks')(grunt, PATTERN_LOAD_TASK)

  # Time how long tasks take. Can help when optimizing build times
  # (require 'time-grunt') grunt

  # Configurable paths for the application
  appConfig =
    client: 'src/client'
    server: 'src/server'
    build: 'build'

  # configure the tasks
  grunt.initConfig
    # Project settings
    config: appConfig

    #Watches files for changes and runs tasks based on the changed files
    watch:
      server:
        files: ['<%= config.server %>/**/*.coffee']
        tasks: ['newer:coffee:server']
      client:
        files: ['<%= config.client %>/scripts/{,**/}*.{coffee,litcoffee}']
        tasks: ['newer:coffee:client']
      styles:
        files: ['<%= config.client %>/styles/{,**/}*.styl']
        tasks: ['newer:stylus:build']
      public:
        files: ['<%= config.client %>/{,**/}*.html']
        tasks: ['newer:copy:public', 'newer:copy:build']
      test:
        files: ['test/server/{,**/}*.{coffee}']
        tasks: ['newer:mochaTest']
      livereload:
        options:
          livereload: true
        files: [
          'build/client/{,*/}*.html'
          'build/client/partials/{,*/}*.html'
          'build/client/styles/{,*/}*.css'
          'build/client/scripts/**/*.js'
          'build/client/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
        ]
      # Front-end test
      testFrontEnd:
        files: ['test/client/**/*.coffee']
        tasks: ['karma']

      testBackEnd:
        files: ['test/server/**/*.coffee']
        tasks: ['mochaTest']

    nodemon:
      dev:
        script: 'build/server/app.js'
        options:
          args: []
          ignore: ['node_modules/**']
          watch: ['build/server', 'Gruntfile.coffee']
          ext: 'js,html'
          nodeArgs: ['--debug']
          env:
            NODE_ENV: 'development'
            NODE_DEBUG: 'drtool'
          cwd: __dirname

    #Copy files.
    copy:
      public:
        files: [
          expand: true
          cwd: '<%= config.client %>/'
          dest: '<%= config.build %>/client/'
          src: '{,*/}*.html'
        ,
          expand: true
          cwd: '<%= config.client %>/images'
          dest: '<%= config.build %>/client/images/'
          src: '{,**/}*.*'
        ]
      build:
        files: [
          expand: true
          cwd: 'src/'
          src: [
            '**'
            '!**/*.{coffee,styl}'
          ]
          dest: 'build/'
        ,
          expand: true
          cwd: 'bower_components/bootstrap/dist'
          src: 'fonts/*'
          dest: '<%= config.build %>/client'
        ]
      instrument:
        files: [
          expand: true
          cwd: 'build/server/'
          src: [
            '**'
            '!**/*.{js,css,html}'
          ]
          dest: 'coverage/instrument/build/server'
        ]
    #Compiles CoffeeScript to JavaScript.
    coffee:
      options:
        bare: true
      server:
        files:[
          expand: true
          cwd: '<%= config.server %>/'
          src: '{,**/**/}*.coffee'
          dest: '<%= config.build %>/server/'
          ext: '.js'
        ]
      client:
        files: [
          expand: true
          cwd: '<%= config.client %>/scripts/'
          src: '{,**/**/}*.coffee'
          dest: '<%= config.build %>/client/scripts/'
          ext: '.js'
        ]
    #Empties build folders.
    clean:
      build:
        options:
          force: true
        src: ['<%= config.build %>']
      coverage:
        options:
          force: true
        src: ['coverage']
    # Karma test settings
    karma:
      unit:
        configFile: 'test/client/karma.conf.coffee'
        singleRun: true
    #Run mocha test
    mochaTest:
      test:
        options:
          globals: 'hasCert,res'
          reporter: 'xunit-file'
          # reporter: 'spec'
          colors: true
          require: [
            'coffee-script'
            'should'
          ]
        src: [
          'test/server/**/*.coffee'
        ]
    #Code style
    coffeelint:
      app: [
        '<%= config.server %>/**/*.coffee'
        '<%= config.client %>/scripts/**/*.coffee'
        'test/**/**/*.coffee'
      ]
      options: coffeeLintRules
    #Compile stylus.
    stylus:
      options:
        compress: false
        linenos: false
        firebug: false
        paths: []
        define: {}
        rawDefine: false
        urlfunc: ""
        use: []
        import: []
        banner: ""
        "include css": false
        "resolve url": false
      build:
        files:
          '<%= config.build %>/client/styles/main.css': [
            '<%= config.client %>/styles/*.styl'
            '<%= config.client %>/styles/**/*.styl'
          ]
    #Instrument the code in a new file.
    instrument:
      files: ["build/server/**/*.js"]
      options:
        lazy: true
        basePath: "coverage/instrument/"
    #For the path where will save the reports the code coverage.
    storeCoverage:
      options:
        dir: 'coverage/reports'
    #For the report task about code coverage.
    makeReport:
      src: "coverage/reports/**/*.json"
      options:
        type: "<%= grunt.task.current.args[0] %>"
        dir: "coverage/reports"
        print: "detail"
    #for the task that would open the browser to show report about code coverage.
    open:
      coverage:
        path: 'coverage/reports/index.html'

    # Concurrent tasks
    concurrent:
      dev:
        tasks: ['nodemon', 'watch']
        options:
          logConcurrentOutput: true

  #Create task to server Up.
  grunt.registerTask 'dev', 'Compile then start a connect web server', (target) ->

    test = grunt.option 'test'

    unless test
      grunt.task.run [
        'build'
        'concurrent:dev'
      ]

    if test is 'karma'
      grunt.task.run [
        'build'
        'watch:testFrontEnd'
      ]

    if test is 'mocha'
      grunt.task.run [
        'build'
        'clean:coverage'
        'copy:instrument'
        'instrument'
        'mochaTest'
        'watch:testBackEnd'
      ]

  #Create task for build the project.
  grunt.registerTask 'build', [
    'clean:build'
    'coffee'
    'stylus:build'
    'copy:build'
  ]

  #Create task for run test.
  grunt.registerTask 'test', [
    'build'
    'clean:coverage'
    'copy:instrument'
    'instrument'
    'mochaTest'
  ]

  #create task for coffelint task
  grunt.registerTask 'lint', ['coffeelint']

  #create task to generate coverage reports
  grunt.registerTask 'coverage', 'Generate coverage reports of the application',
  (target) ->
    grunt.task.run 'build'
    grunt.task.run 'clean:coverage'
    grunt.task.run 'copy:instrument'
    grunt.task.run 'instrument'
    grunt.task.run 'mochaTest'
    # grunt.task.run 'karma'
    grunt.task.run 'storeCoverage'
    if target is 'jenkins'
      grunt.task.run 'makeReport:cobertura'
    else
      grunt.task.run 'makeReport:html'
      grunt.task.run 'open'
  #TODO Task to E2E test
