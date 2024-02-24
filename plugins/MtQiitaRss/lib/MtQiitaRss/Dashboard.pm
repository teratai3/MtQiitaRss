package MtQiitaRss::Dashboard;
use strict;
use warnings;
use utf8;
use LWP::Simple;
use XML::Simple;
use MT::Log;



sub qiita_rss_widget {
    my $app = shift;
    my ( $tmpl, $param ) = @_;
    my $rss_url = 'https://qiita.com/tags/movabletype/feed';

    # RSSフィードを取得
    my $rss_content = get($rss_url);

    return $app->error("RSSフィードを取得できませんでした。") unless $rss_content;

    my $rss = XML::Simple->new( ForceArray => 1 );

    my $data = $rss->XMLin($rss_content);

  

    my @items;
    foreach my $entry ( @{ $data->{entry} } ) {
        my $title = $entry->{title}[0];
        my $url   = $entry->{link}->[0]->{href};  # 'link'は配列リファレンス、最初の要素のhrefを取得
        push @items,
          {
            title => $title,
            url  => $url,
          };
    }

  

    $param->{'items'} = \@items;
}

1;
