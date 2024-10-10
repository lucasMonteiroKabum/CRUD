use FindBin;
use lib "$FindBin::Bin/lib";
use strict;
use warnings;
use Mojolicious::Lite;
use CRUD::Model;
use Mojo::JSON qw(decode_json encode_json);
use Data::Dumper; 

my $model = CRUD::Model->new();

get '/' => sub {
    my $c = shift;

    my $users = $model->list_users();
    $c->stash(users => $users);
    $c->render(template => 'index');
};

# Rota para adicionar usuário via AJAX com JSON
post '/add_user' => sub {
    my $c = shift;

    return $c->render(
        json   => { success => 0, error => 'Content-Type deve ser application/json.' },
        status => 400
    ) unless $c->req->headers->content_type =~ m{application/json};

    my $data = $c->req->json;
    my $name   = $data->{name}   // '';
    my $number = $data->{number} // '';
    my $emails = $data->{emails} // [];

    if ($name eq '' || $number eq '') {
        return $c->render(
            json   => { success => 0, error => 'Nome e Número são obrigatórios.' },
            status => 400
        );
    }

    my $user_id = $model->add_user($name, $number, $emails);

    return $c->render(json => { success => 1, user_id => $user_id });
};

# Rota para obter dados de um usuário pelo UserId
get '/get_user/:id' => sub {
    my $c  = shift;
    my $id = $c->param('id');

    # Buscar usuário
    my $users = $model->getUserById($id);

    my ($user) = grep { $_->{userId} == $id } @$users;

    if ($user) {
        return $c->render(json => { success => 1, user => $user });
    }
    else {
        return $c->render(
            json   => { success => 0, error => 'Usuário não encontrado.' },
            status => 404
        );
    }
};

# Rota para atualizar usuário via AJAX com JSON
post '/update_user' => sub {
    my $c = shift;

    return $c->render(
        json   => { success => 0, error => 'Content-Type deve ser application/json.' },
        status => 400
    ) unless $c->req->headers->content_type =~ m{application/json};

    my $data = $c->req->json;
    my $id     = $data->{id}     // '';
    my $name   = $data->{name}   // '';
    my $number = $data->{number} // '';
    my $emails = $data->{emails} // [];

    if ( $id eq '' || $name eq '' || $number eq '' ) {
        return $c->render(
            json   => { success => 0, error => 'ID, Nome e Número são obrigatórios.' },
            status => 400
        );
    }

    # print Dumper($data); 
    my $updated = $model->update_user( $id, $name, $number, $emails );

    return $c->render(json => { success => 1 });
};

# Rota para deletar usuário via AJAX com JSON
post '/delete_user' => sub {
    my $c = shift;

    return $c->render(
        json   => { success => 0, error => 'Content-Type deve ser application/json.' },
        status => 400
    ) unless $c->req->headers->content_type =~ m{application/json};

    my $data = $c->req->json;
    my $id   = $data->{id} // '';

    if ( $id eq '' ) {
        return $c->render(
            json   => { success => 0, error => 'ID é obrigatório.' },
            status => 400
        );
    }

    $model->delete_user($id);

    return $c->render(json => { success => 1 });
};

app->start;