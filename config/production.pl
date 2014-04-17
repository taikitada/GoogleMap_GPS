use File::Spec;
use File::Basename qw(dirname);
my $basedir = File::Spec->rel2abs(File::Spec->catdir(dirname(__FILE__), '..'));
+{
    'DBI' => [
        "dbi:mysql:database=googlemap_gps",
        'root', '', +{ mysql_enable_utf8 => 1, RaiseError => 1 }
    ],
};
