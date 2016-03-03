(function() {
        window.messages = {
                submit: function() {
                        var content = $("#messageContent").val();
                        if (!content) {
                                alert("请输入留言内容！");
                                return;
                        }
                        $.ajax("/messages.json", {
                                method : "post",
                                headers : {
                                        'X-CSRF-Token' : $( 'meta[name="csrf-token"]' ).attr( 'content' )
                                },
                                data: {
                                        content: content
                                }
                        }).done(function(data) {
                                $("#contactUsModal").modal('hide');
                                alert("感谢您的留言！");
                        });
                }
        };
})();
