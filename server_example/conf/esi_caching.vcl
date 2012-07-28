backend default {
    # Set a host.
    .host = "127.0.0.1";

    # sinatra port
    .port = "4567";
}

sub vcl_recv {
    set req.backend = default;
    return(lookup);
}

sub vcl_miss {
    return(fetch);
}

sub vcl_hit {
    return(deliver);
}

sub vcl_fetch {
    # If header specifies "no-cache", don't cache.
    if (
      beresp.http.Pragma        ~ "no-cache" ||
      beresp.http.Cache-Control ~ "no-cache" ||
      beresp.http.Cache-Control ~ "private"
    ) {
      # return(pass);
    }

    if (req.url ~ "no_magic") {
      # do no ESI eval
    } else {
      # This is the magic sauce
      set beresp.do_esi = true;
    }
}

sub vcl_deliver {
    return(deliver);
}