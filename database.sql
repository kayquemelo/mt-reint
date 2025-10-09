CREATE TABLE IF NOT EXISTS "entidade" (
	"id" UUID NOT NULL UNIQUE,
	"nome" VARCHAR(255),
	"descricao" TEXT,
	-- UUID da entidade pai. caso seja uma entidade raiz, deixar como null.
	"entidade_id" UUID,
	"hostname" VARCHAR(255),
	"ativo" BOOLEAN NOT NULL,
	"created_at" TIMESTAMP NOT NULL,
	"created_by" UUID NOT NULL,
	"updated_at" TIMESTAMP,
	"updated_by" UUID,
	"deleted_at" TIMESTAMP,
	"deleted_by" UUID,
	PRIMARY KEY("id")
);

COMMENT ON TABLE "entidade" IS 'Tabela utilizada para armazenar as tenants/filiais/unidades/empresas em hierarquia.';
COMMENT ON COLUMN "entidade"."entidade_id" IS 'UUID da entidade pai. caso seja uma entidade raiz, deixar como null.';


CREATE TABLE IF NOT EXISTS "usuario" (
	"id" UUID NOT NULL UNIQUE,
	"email" VARCHAR(255) NOT NULL UNIQUE,
	"senha" VARCHAR(255) NOT NULL,
	"recuperacao" VARCHAR(255),
	"token" VARCHAR(255),
	"token_expires" TIMESTAMP,
	"ativo" BOOLEAN NOT NULL,
	"created_at" TIMESTAMP NOT NULL,
	"created_by" UUID NOT NULL,
	"updated_at" TIMESTAMP,
	"updated_by" UUID,
	"deleted_at" TIMESTAMP,
	"deleted_by" UUID,
	PRIMARY KEY("id")
);




CREATE TABLE IF NOT EXISTS "usuario_perfil" (
	"id" UUID NOT NULL UNIQUE,
	"nome" TEXT,
	"apelido" TEXT NOT NULL,
	"descricao" TEXT,
	"foto_path" TEXT,
	"foto_capa_path" TEXT,
	"usuario_id" UUID NOT NULL,
	"entidade_id" UUID NOT NULL,
	"papel_id" UUID NOT NULL,
	"ativo" BOOLEAN NOT NULL,
	"created_at" TIMESTAMP NOT NULL,
	"created_by" UUID NOT NULL,
	"updated_at" TIMESTAMP,
	"updated_by" UUID,
	"deleted_at" TIMESTAMP,
	"deleted_by" UUID,
	PRIMARY KEY("id")
);

COMMENT ON TABLE "usuario_perfil" IS 'Tabela para armazenar os perfis do usuário.';


CREATE TABLE IF NOT EXISTS "rbac_papel" (
	"id" UUID NOT NULL UNIQUE,
	"nome" VARCHAR(255) NOT NULL,
	"descricao" TEXT,
	"entidade_id" UUID NOT NULL,
	"created_at" TIMESTAMP NOT NULL,
	"created_by" UUID NOT NULL,
	"updated_at" TIMESTAMP,
	"updated_by" UUID,
	"deleted_at" TIMESTAMP,
	"deleted_by" UUID,
	PRIMARY KEY("id")
);




CREATE TABLE IF NOT EXISTS "rbac_papel_permissao" (
	"id" UUID NOT NULL,
	"papel_id" UUID NOT NULL,
	"permissao_id" UUID NOT NULL,
	"created_at" TIMESTAMP NOT NULL,
	"created_by" UUID NOT NULL,
	"updated_at" TIMESTAMP,
	"updated_by" UUID,
	"deleted_at" TIMESTAMP,
	"deleted_by" UUID,
	PRIMARY KEY("id")
);




CREATE TABLE IF NOT EXISTS "rbac_permissao" (
	"id" UUID NOT NULL UNIQUE,
	"nome" VARCHAR(255) NOT NULL,
	"descricao" TEXT,
	"modulo_id" UUID NOT NULL,
	"acao" VARCHAR(255) NOT NULL,
	"created_at" TIMESTAMP NOT NULL,
	"created_by" UUID NOT NULL,
	"updated_at" TIMESTAMP,
	"updated_by" UUID,
	"deleted_at" TIMESTAMP,
	"deleted_by" UUID,
	PRIMARY KEY("id")
);




CREATE TABLE IF NOT EXISTS "modulo" (
	"id" UUID NOT NULL UNIQUE,
	"nome" VARCHAR(255) NOT NULL,
	"descricao" TEXT,
	"versao" VARCHAR(255) NOT NULL,
	"ativo" BOOLEAN NOT NULL,
	"created_at" TIMESTAMP NOT NULL,
	"created_by" UUID NOT NULL,
	"updated_at" TIMESTAMP,
	"updated_by" UUID,
	"deleted_at" TIMESTAMP,
	"deleted_by" UUID,
	PRIMARY KEY("id")
);




CREATE TABLE IF NOT EXISTS "auditoria_evento" (
	"id" UUID NOT NULL UNIQUE,
	"tabela" VARCHAR(255) NOT NULL,
	"operacao" VARCHAR(255) NOT NULL,
	"registro_id" UUID NOT NULL,
	"usuario_id" UUID NOT NULL,
	"entidade_id" UUID NOT NULL,
	"registro_anterior" JSONB NOT NULL,
	"registro_novo" JSONB NOT NULL,
	"created_at" TIMESTAMP NOT NULL,
	PRIMARY KEY("id")
);



ALTER TABLE "usuario_perfil"
ADD FOREIGN KEY("usuario_id") REFERENCES "usuario"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "usuario_perfil"
ADD FOREIGN KEY("entidade_id") REFERENCES "entidade"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "usuario_perfil"
ADD FOREIGN KEY("papel_id") REFERENCES "rbac_papel"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "rbac_papel_permissao"
ADD FOREIGN KEY("papel_id") REFERENCES "rbac_papel"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "rbac_papel_permissao"
ADD FOREIGN KEY("permissao_id") REFERENCES "rbac_permissao"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "rbac_permissao"
ADD FOREIGN KEY("modulo_id") REFERENCES "modulo"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "rbac_papel"
ADD FOREIGN KEY("entidade_id") REFERENCES "entidade"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "auditoria_evento"
ADD FOREIGN KEY("usuario_id") REFERENCES "usuario_perfil"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "auditoria_evento"
ADD FOREIGN KEY("entidade_id") REFERENCES "entidade"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
