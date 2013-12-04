'use strict'

angular.module 'timeCounterApp'
  .controller 'MainCtrl', <[$scope $timeout $window $routeParams]> ++ ($scope, $timeout, $window, $routeParams) ->

    $scope.targetChoices = [
      ["again", 0]
      ["again in 1 s", 1]
      ["again in 2 s", 2]
      ["again in 5 s", 5]
      ["again in 10 s", 10]
      ["again in 30 s", 30]
      ["again in 60 s", 60]
      ["again in 120 s", 120]
      ["again in 180 s", 180]
    ]

    $scope.getTargetIndex = (secs) ->
      console.log "secs=#{secs}"
      for t, i in $scope.targetChoices
        console.log t,i
        if secs <= t.1
          return i
      return $scope.targetChoices.length - 1


    $scope.targetIndex = $scope.getTargetIndex (Math.round ~~($routeParams.target ? 0))

    $scope.limit = -> 100 * $scope.target

    # $scope.targetText = -> if $scope.target > 0
    #   "in #{Math.round ~~$scope.target} seconds"
    # else
    #   ""
    $scope.targetText = ->
      $scope.targetChoices[$scope.targetIndex][0]

    $scope.standalone = -> $window.top == $window.self

    $scope.setTarget = (index) ->
      console.log "index = #{index}"
      $scope.targetIndex = index
      $scope.target = $scope.targetChoices[index].1

    $scope.setTarget $scope.targetIndex

    display = $scope.display = {}

    const idle = 'idle'
    const timing = 'timing'

    state = $scope.state = {}
    $scope.lightOn = false

    reset = $scope.reset = ->
      display.ms = '?'
      display.times = []
      state.phase = idle
      state.startTime = 0
      $scope.lightOn = false

    reset!

    $scope.idle = ->
      if $scope.state.phase == idle
        'idling'
        display.ms = '?'
        $scope.lightOn = false
      else
        ''

    $scope.updateTime = ->
      if state.phase == timing
        timeCounting = Date.now! - state.startTime
        if timeCounting >= 150000
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
      $scope.lightOn = true
      display.ms = '?'
      $timeout $scope.updateTime, 500

    stop = $scope.stop = ->
      logTimes!
      state.phase = idle
      $scope.lightOn = false



    click = ->
      switch state.phase
      | idle => counting!
      | timing => stop!
      | otherwise $scope.messages = -> 'invalid phase'
      console.log "LightOn", $scope.lightOn, "Phase", state.phase

    $scope.stageClick = ->
      click!


    return 1
