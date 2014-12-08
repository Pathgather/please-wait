angular.module('pleaseWaitApp', [])
  .controller('MainCtrl', ['$scope', '$window', '$timeout', function($scope, $window, $timeout) {
    var init = false;
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
    $scope.please_wait_spinner_index = 0;
    $scope.show_spinner = true;

    $scope.$watch('please_wait_spinner_index', function(val) {
      if(init) {
        $scope.show_spinner = true
        $scope.please_wait_options.loadingHtml = $scope.please_wait_spinners[$scope.please_wait_spinner_index] + "<p>Have a wonderful day!</p>";
        $scope.updatePleaseWait();
      } else {
        init = true;
      }
    });

    $scope.updatePleaseWait = function() {
      $window.loadingScreen.updateOptions($scope.please_wait_options);
    };
  }]);