var app = angular.module('app', []);

app.factory('Data', function () {
  return {message: "I'm data from a service"}
})

app.filter('reverse', function (Data) {
  return function (text) {
   return text.split('').reverse().join('') + Data.message; 
  }
});

function firstCtrl ($scope, Data) {
  $scope.data = Data;
}

function secondCtrl ($scope, Data) {
  $scope.data = Data;
  
  $scope.reversedMessage = function (message) {
    return message.split('').reverse().join('');
  }
}

