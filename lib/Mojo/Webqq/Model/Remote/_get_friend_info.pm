use strict;
sub Mojo::Webqq::Model::_get_friend_info{
    my $self = shift;
    my $uin = shift;
    my $api_url = 'http://s.web2.qq.com/api/get_friend_info2';
    my $headers = {Referer=>'http://s.web2.qq.com/proxy.html?v=20130916001&callback=1&id=1',json=>1};
    my @query_string = (
        tuin            =>  $uin,
        vfwebqq         =>  $self->vfwebqq,
        clientid        =>  $self->clientid,
        psessionid      =>  $self->psessionid,
        t               =>  time,
    ); 

    my $json = $self->http_get($self->gen_url($api_url,@query_string),$headers);
    return undef unless defined $json;
    return undef if $json->{retcode} !=0;
    my $friend_info = $json->{result};
    $friend_info->{birthday} = join("-",@{ $friend_info->{birthday}}{qw(year month day)}  );
    $friend_info{state} = $self->code2state(delete $friend_info->{'stat'});
    $friend_info->{id} = delete $friend_info->{uin};
    $self->reform_hash($friend_info);
    return $friend_info;
}
1;
