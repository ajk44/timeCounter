'use strict'

angular.module 'timeCounterApp'
  .controller 'MainCtrl', <[$scope $timeout $window]> ++ ($scope,$timeout,$window) ->


    
    display = $scope.display = {}
    
    const idle = 'idle'
    const timing = 'timing'

    state = $scope.state = {}

    reset = $scope.reset = ->
      display.ms = '?'
      display.times = []
      state.phase = idle
      state.startTime = 0
      

    reset!

    


    $scope.idle = ->
      if $scope.state.phase == idle
        'idling'
        display.ms = '?'
      else
        ''

    $scope.updateTime = ->
      if state.phase == timing
        timeCounting = Date.now! - state.startTime
        if timeCounting >= 30000
          stop!
        else
          $timeout $scope.updateTime, 20

    logTimes = ->
      display.ms = Date.now! - state.startTime
      display.times[*] = ms: display.ms
     
 
    $scope.clearLog = ->
      display.times = []
    

    counting = $scope.counting = ->
      state.phase = timing
      state.startTime = Date.now!
      $timeout $scope.updateTime, 500
    
    stop = $scope.stop = ->
      logTimes!
      state.phase = idle
      

    click = ->
      switch state.phase
      | idle => counting!
      | timing => stop!
      | otherwise $scope.messages = -> 'invalid phase'
      console.log state.phase

    $scope.stageClick = ->
      click! 

    
    return 1
