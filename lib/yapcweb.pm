package yapcweb;

use Dancer ':syntax';
use Dancer::Plugin::I18N;
use Dancer::Plugin::Email;
use HTTP::AcceptLanguage;

our $VERSION = '0.1';

prefix '/';

hook before_template => sub {
	my $tokens = shift;
	$tokens->{uri_base} = request->base->path eq '/' ? '' : request->base->path;	
	$tokens->{'index'}  = uri_for('/');
};


get '/' => sub {

	my $accept_language = HTTP::AcceptLanguage->new(request->accept_language);
	session user_lang => $accept_language;
	
	template 'index';
};


get '/:opt_lang' => sub {

	my $opt_lang = param('opt_lang');
	session user_lang => $opt_lang;

	template 'index';
};

post '/' => sub {

	my %talk;

	$talk{name}		= params->{nomePalestrante};
	$talk{email}	= params->{emailPalestrante};
	$talk{title}	= params->{tituloPalestrante};
	$talk{abstract}	= params->{resumoPalestrante};

	email {
		from 	=> 'YAPC Brasil',
		to   	=> 'yapc-curitiba@googlegroups.com',
		subject	=> 'Nova Palestra',
		body	=> "Nome: $talk{name}\nE-mail: $talk{email}\nTítulo: $talk{title}\nResumo: $talk{abstract}\n",
	};

    email {
        from    => 'YAPC Brasil',
        to      => "$talk{email}",
        subject => 'Palestra Enviada',
        body    => "Olá $talk{name},\n sua palestra entitulada: $talk{abstract} foi enviada com sucesso.\nIremos avaliar sua proposta e logo retornaremos uma resposta.",
    };

	redirect '/';	
};

true;


























