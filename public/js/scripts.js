
$(document).ready(function() {

    $('#addNumber, #editNumber').mask('(00) 00000-0000');

    $('#addNumber, #editNumber').on('input', function() {
        this.value = this.value.replace(/[^0-9\(\)\s\-]/g, '');
    });

    function addEmailField(container) {
        const emailGroup = `
            <div class="input-group mb-2 email-group">
                <input type="email" class="form-control email-input" name="emails[]" placeholder="Email" required>
                <button type="button" class="btn btn-danger remove-email-btn">Remover</button>
            </div>
        `;
        $(container).append(emailGroup);
    }

    // Evento para adicionar email no modal de Adicionar Usuário
    $('#addMoreEmailsBtn').click(function() {
        addEmailField('#addEmailsContainer');
        
        $('.remove-email-btn').show();
    });

    // Evento para adicionar email no modal de Editar Usuário
    $('#editAddMoreEmailsBtn').click(function() {
        addEmailField('#editEmailsContainer');
    });

    // Evento para remover um campo de email
    $(document).on('click', '.remove-email-btn', function() {
        $(this).closest('.email-group').remove();
    });

    // Adicionar Usuário
    $('#addUserForm').submit(function(e) {
        e.preventDefault();
        const name = $('#addName').val();
        const number = $('#addNumber').val();
        const emails = [];
        $('#addEmailsContainer .email-input').each(function() {
            const email = $(this).val().trim();
            if (email) {
                emails.push(email);
            }
        });

        $.ajax({
            url: '/add_user',
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({ name, number, emails }),
            success: function(response) {
                if (response.success) {
                    location.reload();
                } else {
                    alert(response.error);
                }
            },
            error: function(xhr) {
                alert(xhr.responseJSON ? xhr.responseJSON.error : 'Erro ao adicionar usuário.');
            }
        });
    });

    // Editar Usuário - Abrir Modal e Carregar Dados
    $('.edit-btn').click(function() {
        const userId = $(this).data('id');

        $.ajax({
            url: `/get_user/${userId}`,
            method: 'GET',
            success: function(response) {
                if (response.success) {
                    const user = response.user;
                    $('#editUserId').val(user.userId);
                    $('#editName').val(user.name);
                    $('#editNumber').val(user.phone);
                   
                    $('#editEmailsContainer').empty();
                    
                    const emails = user.emails.split(',').map(email => email.trim());
                    emails.forEach(function(email) {
                        const emailGroup = `
                            <div class="input-group mb-2 email-group">
                                <input type="email" class="form-control email-input" name="emails[]" value="${email}" placeholder="Email" required>
                                <button type="button" class="btn btn-danger remove-email-btn">Remover</button>
                            </div>
                        `;
                        $('#editEmailsContainer').append(emailGroup);
                    });
                    
                    // Se houver apenas um email, esconder o botão de remover
                    if (emails.length <= 1) {
                        $('.remove-email-btn').hide();
                    } else {
                        $('.remove-email-btn').show();
                    }

                    $('#editUserModal').modal('show');
                } else {
                    alert(response.error);
                }
            },
            error: function() {
                alert('Erro ao carregar dados do usuário.');
            }
        });
    });

    // Atualizar Usuário
    $('#editUserForm').submit(function(e) {
        e.preventDefault();
        const id = $('#editUserId').val();
        const name = $('#editName').val();
        const number = $('#editNumber').val();
        const emails = [];
        $('#editEmailsContainer .email-input').each(function() {
            const email = $(this).val().trim();
            if (email) {
                emails.push(email);
            }
        });

        $.ajax({
            url: '/update_user',
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({ id, name, number, emails }),
            success: function(response) {
                if (response.success) {
                    location.reload();
                } else {
                    alert(response.error);
                }
            },
            error: function(xhr) {
                alert(xhr.responseJSON ? xhr.responseJSON.error : 'Erro ao atualizar usuário.');
            }
        });
    });

    // Excluir Usuário - COnfirm
    $('.delete-btn').click(function() {
        const userId = $(this).data('id');
        $('#deleteUserId').val(userId);
        $('#deleteUserModal').modal('show');
    });

    // Deletar Usuário
    $('#deleteUserForm').submit(function(e) {
        e.preventDefault();
        const id = $('#deleteUserId').val();

        $.ajax({
            url: '/delete_user',
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({ id }),
            success: function(response) {
                if (response.success) {
                    location.reload();
                } else {
                    alert(response.error);
                }
            },
            error: function(xhr) {
                alert(xhr.responseJSON ? xhr.responseJSON.error : 'Erro ao deletar usuário.');
            }
        });
    });
});
