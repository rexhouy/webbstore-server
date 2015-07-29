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

	var checkTel = function(checkTelExistence) {
		var tel = $("#user_tel").val();
		if (tel == null || tel.length != 11 || isNaN(tel)) {
			alert("请输入合法的手机号");
			return null;
		}
		return tel;
	};

	var cancelCoolDown = false;
	var coolDown = function(time) {
		if (time === 0 || cancelCoolDown) {
			$("#wizard").removeAttr("disabled").html("获取验证码");
			cancelCoolDown = false;
			return;
		}
		$("#wizard").html("获取验证码("+time+")");
		setTimeout(function(){
			coolDown(time-1);
		}, 1000);
	};

	var checkPhotoCaptcha = function() {
		var captcha = $("#captcha").val();
		if (!captcha) {
			alert("请输入图形验证码");
			return null;
		}
		return captcha;
	};

	auth.castCaptcha = function() {
		var photoCaptcha = checkPhotoCaptcha();
		if (!photoCaptcha) {
			return;
		}
		var tel = checkTel();
		if (!tel) {
			return;
		}
		$("#wizard").attr("disabled", "disabled");
		$.get("/users/captcha", {
			tel : tel,
			captcha : photoCaptcha,
			template_id : $("#template_id").val()
		}).done(function(data){
			if (data != "ok") {
				cancelCoolDown = true;
				alert(data);
			}
			coolDown(60);
		});
	};

	window.auth = auth;

	$(function(){
		$(".simple_captcha_image").click(function() {
			var href = $(".simple_captcha_refresh_button a").attr("href");
			$.get(href).done(function(data){
				eval(data);
			});
		});
	});

})();
