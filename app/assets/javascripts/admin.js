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
//= require jquery_ujs
//= require_tree ./admin-common
//= require Chart.min.js
//= require redactor-rails
//= require jquery.datetimepicker.min.js
//= require_tree ./redactor-rails
//= require redactor-rails/langs/zh_cn

Date.parseDate = function( input, format ){
        return Date.parse(input);
};
Date.prototype.dateFormat = function( format ){
        switch( format ){
        case "YYYY-MM-DD HH:mm:ss":
                return this.getFullYear() + "-" + (this.getMonth()+ 1) + "-" + this.getDate()+ " " + this.getHours() + ":00:00";
        case "HH":
                return this.getHours();
        case "YYYY-MM-DD":
                return this.getFullYear() + "-" + (this.getMonth()+ 1) + "-" + this.getDate();
        }
        // or default format
        return this.getDate()+'.'+(this.getMonth()+ 1)+'.'+this.getFullYear();
};
