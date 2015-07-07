// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets

(function(){
	
	var auth = {};

	var checkTel = function() {
		var tel = $("#user_tel").val();
		if (tel == null || tel.length != 11 || isNaN(tel)) {
			alert("请输入合法的手机号");
			return null;
		}
		return tel;
	};

	var coolDown = function(time) {
		if (time === 0) {
			$("#wizard").removeAttr("disabled").html("获取验证码");
			return;
		}
		$("#wizard").html("获取验证码("+time+")");
		setTimeout(function(){
			coolDown(time-1);
		}, 1000);
	};

	auth.castCaptcha = function() {
		var tel = checkTel();
		if (!tel) {
			return;
		}
		$("#wizard").attr("disabled", "disabled");
		coolDown(60);
		$.get("/users/captcha", {
			tel : tel
		});
	};

	window.auth = auth;

})();
