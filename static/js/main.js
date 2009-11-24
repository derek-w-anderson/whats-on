function set_focus()
{
    $("input#channel").focus();
}

function query_shows()
{
    $("div#response").fadeOut('def', function() {
        
        /* Display the loading gif. */
        $("div#response").empty().html('<img id="loading" src="/static/images/load.gif" width="32" height="32" alt="loading">');
        $("div#response").fadeIn('def');
        
        var channel = $("#channel").val();
        var timezone = $("#timezone").val();
    
        /* No channel specified - display error message. */
        if (channel == '') {
            $("div#response").fadeOut('def', function() {
                $("div#response").empty().html('<span class="error">You must specify the channel.</span>');
                $("div#response").fadeIn('def');
            });
        
        /* Make a request for XML data with show information based on the given channel and timezone. */
        } else {
		    $.ajax({
		        type: "GET",
			    url: "/query/" + escape(channel) + "/" + timezone,
			    dataType: "xml",
			    cache: false,
			    
			    /* Success! Test to see if a show was found and fade-in the result. */
			    success: function(xml) {
                    $("div#response").fadeOut('def', function() {
			            $(xml).find('show').each(function() {
			                if ($(this).find('found').text() == "true") {
                                $("div#response").empty().html('<span class="success"><strong>' + $(this).find('name').text() + '</strong>, which started at <strong>' + $(this).find('start').text() + '</strong> and ends at <strong>' + $(this).find('end').text() + '</strong>.</span>'); 
                            } else {
                                $("div#response").empty().html('<span class="error">I can\'t find that channel. Perhaps you misspelled it?</span>');
                            }
                            $("div#response").fadeIn('def');
                        });
			        });
			    },
			    
			    /* Woops... An error occurred during the request for XML data. */
			    error: function() {
                    $("div#response").fadeOut('def', function() {
                        $("div#response").empty().html('<span class="error">An error occurred while processing your request.</span>');
                        $("div#response").fadeIn('def');
                    });
			    }
		    });
        }
    });
}

