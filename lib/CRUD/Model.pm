package CRUD::Model;
use strict;
use warnings;
use DBI;

sub new {
    my ($class) = @_;
    my $self = {};

    my $dsn = "DBI:mysql:database=crud;host=localhost";
    my $username = "lucas";
    my $password = "root";

    my $dbh = DBI->connect($dsn, $username, $password, {
        RaiseError => 1,
        AutoCommit => 1,
    }) or die "Não foi possível conectar ao banco de dados: $DBI::errstr";

    $self->{dbh} = $dbh;
    bless $self, $class;
    return $self;
}

sub list_users {
    my ($self) = @_;
    my $dbh = $self->{dbh};
    my $sth = $dbh->prepare("
        SELECT u.userId, u.name, u.phone, GROUP_CONCAT(e.email SEPARATOR ', ') AS emails
        FROM users u
        LEFT JOIN emails e ON u.userId = e.userId
        GROUP BY u.userId
    ");
    $sth->execute();
    my @users;
    while (my $row = $sth->fetchrow_hashref) {
        push @users, $row;
    }
    return \@users;
}

sub getUserById {
    my ($self, $id) = @_;
    my $dbh = $self->{dbh};
    my $sth = $dbh->prepare("
        SELECT u.userId, u.name, u.phone, GROUP_CONCAT(e.email SEPARATOR ', ') AS emails
        FROM users u
        LEFT JOIN emails e ON u.userId = e.userId
        WHERE u.userId = ?
        GROUP BY u.userId
    ");
    $sth->execute($id);
    my @users;
    while (my $row = $sth->fetchrow_hashref) {
        push @users, $row;
    }
    return \@users;
}

# Add usuário
sub add_user {
    my ($self, $name, $number, $emails) = @_;
    my $dbh = $self->{dbh};

    my $sth = $dbh->prepare("INSERT INTO users (name, phone) VALUES (?, ?)");
    $sth->execute($name, $number);
    my $user_id = $dbh->{mysql_insertid};

    if (@$emails) {
        my $email_sth = $dbh->prepare("INSERT INTO emails (userId, email) VALUES (?, ?)");
        foreach my $email (@$emails) {
            $email_sth->execute($user_id, $email);
        }
    }

    return $user_id;
}

sub update_user {
    my ($self, $id, $name, $number, $emails) = @_;
    my $dbh = $self->{dbh};

    my $sth = $dbh->prepare("UPDATE users SET name = ?, phone = ? WHERE userId = ?");
    $sth->execute($name, $number, $id);

    my $del_sth = $dbh->prepare("DELETE FROM emails WHERE userId = ?");
    $del_sth->execute($id);

    if (@$emails) {
        my $email_sth = $dbh->prepare("INSERT INTO emails (userId, email, dt_insert, dt_update) VALUES (?, ?, now(), now())");
        foreach my $email (@$emails) {
            $email_sth->execute($id, $email);
        }
    }

    return 1;
}

# Deletar um usuário
sub delete_user {
    my ($self, $id) = @_;
    my $dbh = $self->{dbh};

    my $sth = $dbh->prepare("DELETE FROM users WHERE userId = ?");
    $sth->execute($id);

    return 1;
}

1;
