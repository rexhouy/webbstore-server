(function(){
        var init_redactor = function(){
                var csrf_token = $('meta[name=csrf-token]').attr('content');
                var csrf_param = $('meta[name=csrf-param]').attr('content');
                var params;
                if (csrf_param !== undefined && csrf_token !== undefined) {
                        params = csrf_param + "=" + encodeURIComponent(csrf_token);
                }
                $('#product_article').redactor({
                        "imageUpload":"/admin/image?" + params,
                        "lang":"zh_cn"
                });
                $('#article_content').redactor({
                        "imageUpload":"/admin/image?" + params,
                        "lang":"zh_cn"
                });
        };

        $(function(){
                init_redactor();
        });

})();
