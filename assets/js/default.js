angular.module('pleaseWaitApp', [])
  .controller('MainCtrl', ['$scope', '$window', '$timeout', function($scope, $window, $timeout) {
    var init = false;
    $scope.show_options = true;
    $scope.loading_message = "";
    $scope.show_demo = true;
    $scope.please_wait_options = {
      backgroundColor: '#f46d3b',
      loadingHtml: '<div class="sk-spinner sk-spinner-rotating-plane"></div>'
    };
    $scope.please_wait_spinners = [
      '<div class="sk-spinner sk-spinner-rotating-plane"></div>',
      '<div class="sk-spinner sk-spinner-double-bounce"><div class="sk-double-bounce1"></div><div class="sk-double-bounce2"></div></div>',
      '<div class="sk-spinner sk-spinner-wave"><div class="sk-rect1"></div><div class="sk-rect2"></div><div class="sk-rect3"></div><div class="sk-rect4"></div><div class="sk-rect5"></div></div>',
      '<div class="sk-spinner sk-spinner-wandering-cubes"><div class="sk-cube1"></div><div class="sk-cube2"></div></div>',
      '<div class="sk-spinner sk-spinner-pulse"></div>',
      '<div class="sk-spinner sk-spinner-chasing-dots"><div class="sk-dot1"></div><div class="sk-dot2"></div></div>',
      '<div class="sk-spinner sk-spinner-three-bounce"><div class="sk-bounce1"></div><div class="sk-bounce2"></div><div class="sk-bounce3"></div></div>',
      '<div class="sk-spinner sk-spinner-circle"><div class="sk-circle1 sk-circle"></div><div class="sk-circle2 sk-circle"></div><div class="sk-circle3 sk-circle"></div><div class="sk-circle4 sk-circle"></div><div class="sk-circle5 sk-circle"></div><div class="sk-circle6 sk-circle"></div><div class="sk-circle7 sk-circle"></div><div class="sk-circle8 sk-circle"></div><div class="sk-circle9 sk-circle"></div><div class="sk-circle10 sk-circle"></div><div class="sk-circle11 sk-circle"></div><div class="sk-circle12 sk-circle"></div></div>',
      '<div class="sk-spinner sk-spinner-cube-grid"><div class="sk-cube"></div><div class="sk-cube"></div><div class="sk-cube"></div><div class="sk-cube"></div><div class="sk-cube"></div><div class="sk-cube"></div><div class="sk-cube"></div><div class="sk-cube"></div><div class="sk-cube"></div></div>',
      '<div class="sk-spinner sk-spinner-fading-circle"><div class="sk-circle1 sk-circle"></div><div class="sk-circle2 sk-circle"></div><div class="sk-circle3 sk-circle"></div><div class="sk-circle4 sk-circle"></div><div class="sk-circle5 sk-circle"></div><div class="sk-circle6 sk-circle"></div><div class="sk-circle7 sk-circle"></div><div class="sk-circle8 sk-circle"></div><div class="sk-circle9 sk-circle"></div><div class="sk-circle10 sk-circle"></div><div class="sk-circle11 sk-circle"></div><div class="sk-circle12 sk-circle"></div></div>'
    ];
    $scope.random_messages = [
      "Hey, we're hiring! Reach out at tech@pathgather.com",
      "Hey you. Welcome back!",
      "You look nice today",
      "Amazing things come to those who wait",
      "You usually have to wait for that which is worth waiting for",
      "If you spend your whole life waiting for the storm, you'll never enjoy the sunshine",
      "Don't wait for the perfect moment. Take the moment and make it perfect",
      "Don't wait for opportunity. Create it.",
      "Glorious things are waiting for you. We're just getting them ready.",
      "Enjoy PleaseWait.js responsibly."
    ]
    $scope.please_wait_spinner_index = 2;
    updateLoadingHtml = function() {
      $scope.please_wait_options.loadingHtml = "<p class='loading-message'>" + $scope.loading_message + "</p>" + $scope.please_wait_spinners[$scope.please_wait_spinner_index];
    };

    $scope.$watch('please_wait_spinner_index', function(val) {
      if(init) {
        $scope.updatePleaseWait();
      } else {
        init = true;
      }
    });

    $scope.updatePleaseWait = function() {
      updateLoadingHtml();
      $window.loading_screen.updateOptions($scope.please_wait_options);
    };

    $scope.randomizeMessage = function() {
      $scope.loading_message = $scope.random_messages[Math.floor(Math.random() * $scope.random_messages.length)];
      updateLoadingHtml();
      $window.loading_screen.updateOptions($scope.please_wait_options);
    };

    $scope.showLoginForm = function() {
      $window.loading_screen.updateOption('loadingHtml',
        '<form role="form" class="form-horizontal fake-login">' +
        '<p>Please login in order to proceed</p>' +
        '<div class="form-group">' +
        '<div class="input-group">' +
        '<div class="input-group-addon">' +
        '<i class="fa fa-envelope"></i>' +
        '</div>' +
        '<input type="email" class="form-control" id="pwFakeEmail" placeholder="Email">' +
        '</div>' +
        '</div>' +
        '<div class="form-group">' +
        '<div class="input-group">' +
        '<div class="input-group-addon">' +
        '<i class="fa fa-key"></i>' +
        '</div>' +
        '<input type="password" class="form-control" id="pwFakePassword" placeholder="Password">' +
        '</div>' +
        '</div>' +
        '</form>'
      )
    };

    $scope.toggleDemo = function() {
      $scope.show_demo = !$scope.show_demo;
      if($scope.show_demo) {
        $window.loading_screen = $window.pleaseWait({
          logo: "assets/images/pathgather.png",
          backgroundColor: '#f46d3b',
          loadingHtml: "<p class='loading-message'></p><div class='sk-spinner sk-spinner-rotating-plane'></div>"
        });
      } else {
        $window.loading_screen.finish();
      }
    };
  }]);