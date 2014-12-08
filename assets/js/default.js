angular.module('pleaseWaitApp', [])
  .controller('MainCtrl', ['$scope', '$window', function($scope, $window) {
    $scope.please_wait_options = {
      backgroundColor: '#f46d3b',
      loadingHtml: '<div class="sk-spinner sk-spinner-rotating-plane"></div>'
    };
    $scope.please_wait_spinners = [
      '<div class="sk-spinner sk-spinner-rotating-plane"></div>',
      '<div class="sk-spinner sk-spinner-double-bounce"><div class="sk-double-bounce1"></div><div class="sk-double-bounce2"></div></div>'
    ];
    $scope.please_wait_spinner_index = 0;

    $scope.$watch('please_wait_spinner_index', function(val) {
      $scope.please_wait_options.loadingHtml = $scope.please_wait_spinners[$scope.please_wait_spinner_index];
      $scope.updatePleaseWait();
    });

    $scope.updatePleaseWait = function() {
      $window.loadingScreen.updateOptions($scope.please_wait_options);
    };
  }]);