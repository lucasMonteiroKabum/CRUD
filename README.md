## Executando Aplicação

#### Comando de Execução
 Abra o terminal, navegue até o diretório do projeto e execute o seguinte comando:
```
perl app.pl daemon
```

## Saída Esperada:
```
Server avaliable at http://127.0.0.1:3000
```

## Banco

```
CREATE DATABASE IF NOT EXISTS crud;
USE crud

CREATE TABLE emails (
  emailId int NOT NULL,
  userId int NOT NULL,
  email varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  dt_insert timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  dt_update timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE users (
  userId int NOT NULL,
  name varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  phone varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  dt_insert timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  dt_update timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `emails`
  ADD PRIMARY KEY (`emailId`),
  ADD KEY `userId` (`userId`);

--
-- Índices de tabela `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`userId`);

--
-- AUTO_INCREMENT de tabela `emails`
--
ALTER TABLE `emails`
  MODIFY `emailId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de tabela `users`
--
ALTER TABLE `users`
  MODIFY `userId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;


-- Restrições para tabelas `emails`
--
ALTER TABLE `emails`
  ADD CONSTRAINT `emails_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`) ON DELETE CASCADE;
COMMIT;

```
