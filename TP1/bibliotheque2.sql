PGDMP                         |           db_tp1 #   15.7 (Ubuntu 15.7-0ubuntu0.23.10.1) #   15.7 (Ubuntu 15.7-0ubuntu0.23.10.1) I    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16390    db_tp1    DATABASE     r   CREATE DATABASE db_tp1 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'fr_FR.UTF-8';
    DROP DATABASE db_tp1;
                userpostgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                pg_database_owner    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                   pg_database_owner    false    4            �            1255    16783    AuteurPréféréDe(integer)    FUNCTION     �   CREATE FUNCTION public."AuteurPréféréDe"("numClient" integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$BEGIN
	RETURN "unAuteur", count("unAuteur") FROM contrat GROUP BY "unAuteur";
END;$$;
 @   DROP FUNCTION public."AuteurPréféréDe"("numClient" integer);
       public          userpostgres    false    4            �            1255    16794    PrixDunLivreAugmente()    FUNCTION     �   CREATE FUNCTION public."PrixDunLivreAugmente"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

	IF NEW.prix > OLD.prix * 1.1 THEN 
		RETURN NULL;
	ELSE 
		RETURN NEW;
	END IF;

END;$$;
 /   DROP FUNCTION public."PrixDunLivreAugmente"();
       public          userpostgres    false    4            �            1255    16774    TousLesExemplairesDe(text)    FUNCTION     S  CREATE FUNCTION public."TousLesExemplairesDe"("titreDuLivre" text) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $$DECLARE
	exemplaire integer;
BEGIN
	FOR exemplaire IN 
		SELECT "noExemplaire" FROM exemplaire,livre
		WHERE "leLivre" = "noLivre" AND "titreDuLivre" = "titre"
	LOOP
		RETURN NEXT exemplaire;
	END LOOP;
	RETURN;
END;$$;
 B   DROP FUNCTION public."TousLesExemplairesDe"("titreDuLivre" text);
       public          userpostgres    false    4            �            1255    16787    test()    FUNCTION       CREATE FUNCTION public.test() RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $$DECLARE 
	res integer;
BEGIN
	FOR res IN
		SELECT "unAuteur", count("unAuteur") FROM a_ecrit GROUP BY "unAuteur", count("unAuteur")
	LOOP
		RETURN NEXT res;
	END LOOP;
	RETURN;
END;$$;
    DROP FUNCTION public.test();
       public          userpostgres    false    4            �            1259    16709    a_ecrit    TABLE     a   CREATE TABLE public.a_ecrit (
    "unLivre" integer NOT NULL,
    "unAuteur" integer NOT NULL
);
    DROP TABLE public.a_ecrit;
       public         heap    userpostgres    false    4            �            1259    16396    auteur    TABLE     �   CREATE TABLE public.auteur (
    "noAuteur" integer NOT NULL,
    "nomAuteur" character(40) NOT NULL,
    "prenomAuteur" character(40) NOT NULL,
    "emailAuteur" character(60) NOT NULL
);
    DROP TABLE public.auteur;
       public         heap    userpostgres    false    4            �            1259    16763 %   ListeDesAuteursQuiNontPasEcritDeLivre    VIEW       CREATE VIEW public."ListeDesAuteursQuiNontPasEcritDeLivre" AS
 SELECT auteur."noAuteur",
    auteur."nomAuteur",
    auteur."prenomAuteur",
    auteur."emailAuteur"
   FROM public.auteur
  WHERE (NOT (auteur."noAuteur" IN ( SELECT a_ecrit."unAuteur"
           FROM public.a_ecrit)));
 :   DROP VIEW public."ListeDesAuteursQuiNontPasEcritDeLivre";
       public          userpostgres    false    221    215    215    215    215    4            �            1259    16412    livre    TABLE     �   CREATE TABLE public.livre (
    "noLivre" bigint NOT NULL,
    "typeLivre" text NOT NULL,
    titre text NOT NULL,
    prix real NOT NULL,
    "unEditeur" text
);
    DROP TABLE public.livre;
       public         heap    userpostgres    false    4            �            1259    16759 ,   ListeDesLivresQuiNontEtaientEcritParPersonne    VIEW       CREATE VIEW public."ListeDesLivresQuiNontEtaientEcritParPersonne" AS
 SELECT livre."noLivre",
    livre.titre
   FROM public.livre
EXCEPT
 SELECT a_ecrit."unLivre" AS "noLivre",
    livre.titre
   FROM public.a_ecrit,
    public.livre
  WHERE (a_ecrit."unLivre" = livre."noLivre");
 A   DROP VIEW public."ListeDesLivresQuiNontEtaientEcritParPersonne";
       public          userpostgres    false    217    217    221    4            �            1259    16423 
   exemplaire    TABLE     �   CREATE TABLE public.exemplaire (
    "noExemplaire" integer NOT NULL,
    "leLivre" integer NOT NULL,
    "dateAchat" date DEFAULT now(),
    "leClient" integer
);
    DROP TABLE public.exemplaire;
       public         heap    userpostgres    false    4            �            1259    16767 #   ListeDesLivresQuiNontPasDexemplaire    VIEW       CREATE VIEW public."ListeDesLivresQuiNontPasDexemplaire" AS
 SELECT livre."noLivre",
    livre."typeLivre",
    livre.titre,
    livre.prix,
    livre."unEditeur"
   FROM public.livre
  WHERE (NOT (livre."noLivre" IN ( SELECT exemplaire."leLivre"
           FROM public.exemplaire)));
 8   DROP VIEW public."ListeDesLivresQuiNontPasDexemplaire";
       public          userpostgres    false    217    217    217    218    217    217    4            �            1259    16712    auteur_noAuteur_seq    SEQUENCE     �   CREATE SEQUENCE public."auteur_noAuteur_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."auteur_noAuteur_seq";
       public          userpostgres    false    215    4            �           0    0    auteur_noAuteur_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."auteur_noAuteur_seq" OWNED BY public.auteur."noAuteur";
          public          userpostgres    false    222            �            1259    16405    client    TABLE     �   CREATE TABLE public.client (
    "noClient" integer NOT NULL,
    "nomClient" character(40) NOT NULL,
    "prenomClient" character(40) NOT NULL,
    "emailClient" character(60) NOT NULL
);
    DROP TABLE public.client;
       public         heap    userpostgres    false    4            �            1259    16713    client_noClient_seq    SEQUENCE     �   CREATE SEQUENCE public."client_noClient_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."client_noClient_seq";
       public          userpostgres    false    4    216            �           0    0    client_noClient_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."client_noClient_seq" OWNED BY public.client."noClient";
          public          userpostgres    false    223            �            1259    16459    contrat    TABLE     i   CREATE TABLE public.contrat (
    "unAuteur" integer NOT NULL,
    "unEditeur" character(40) NOT NULL
);
    DROP TABLE public.contrat;
       public         heap    userpostgres    false    4            �            1259    16464    ecrit    TABLE     _   CREATE TABLE public.ecrit (
    "unAuteur" integer NOT NULL,
    "unLivre" integer NOT NULL
);
    DROP TABLE public.ecrit;
       public         heap    userpostgres    false    4            �            1259    16391    editeur    TABLE     m   CREATE TABLE public.editeur (
    "nomEditeur" character(40) NOT NULL,
    adresse character(60) NOT NULL
);
    DROP TABLE public.editeur;
       public         heap    userpostgres    false    4            �            1259    16714    exemplaire_noExemplaire_seq    SEQUENCE     �   CREATE SEQUENCE public."exemplaire_noExemplaire_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public."exemplaire_noExemplaire_seq";
       public          userpostgres    false    4    218            �           0    0    exemplaire_noExemplaire_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."exemplaire_noExemplaire_seq" OWNED BY public.exemplaire."noExemplaire";
          public          userpostgres    false    224            �            1259    16715    livre_noLivre_seq    SEQUENCE     �   CREATE SEQUENCE public."livre_noLivre_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public."livre_noLivre_seq";
       public          userpostgres    false    4    217            �           0    0    livre_noLivre_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public."livre_noLivre_seq" OWNED BY public.livre."noLivre";
          public          userpostgres    false    225            �           2604    16716    auteur noAuteur    DEFAULT     v   ALTER TABLE ONLY public.auteur ALTER COLUMN "noAuteur" SET DEFAULT nextval('public."auteur_noAuteur_seq"'::regclass);
 @   ALTER TABLE public.auteur ALTER COLUMN "noAuteur" DROP DEFAULT;
       public          userpostgres    false    222    215            �           2604    16717    client noClient    DEFAULT     v   ALTER TABLE ONLY public.client ALTER COLUMN "noClient" SET DEFAULT nextval('public."client_noClient_seq"'::regclass);
 @   ALTER TABLE public.client ALTER COLUMN "noClient" DROP DEFAULT;
       public          userpostgres    false    223    216            �           2604    16718    exemplaire noExemplaire    DEFAULT     �   ALTER TABLE ONLY public.exemplaire ALTER COLUMN "noExemplaire" SET DEFAULT nextval('public."exemplaire_noExemplaire_seq"'::regclass);
 H   ALTER TABLE public.exemplaire ALTER COLUMN "noExemplaire" DROP DEFAULT;
       public          userpostgres    false    224    218            �           2604    16719    livre noLivre    DEFAULT     r   ALTER TABLE ONLY public.livre ALTER COLUMN "noLivre" SET DEFAULT nextval('public."livre_noLivre_seq"'::regclass);
 >   ALTER TABLE public.livre ALTER COLUMN "noLivre" DROP DEFAULT;
       public          userpostgres    false    225    217            �          0    16709    a_ecrit 
   TABLE DATA           8   COPY public.a_ecrit ("unLivre", "unAuteur") FROM stdin;
    public          userpostgres    false    221   X       �          0    16396    auteur 
   TABLE DATA           X   COPY public.auteur ("noAuteur", "nomAuteur", "prenomAuteur", "emailAuteur") FROM stdin;
    public          userpostgres    false    215   4X       �          0    16405    client 
   TABLE DATA           X   COPY public.client ("noClient", "nomClient", "prenomClient", "emailClient") FROM stdin;
    public          userpostgres    false    216   �X       �          0    16459    contrat 
   TABLE DATA           :   COPY public.contrat ("unAuteur", "unEditeur") FROM stdin;
    public          userpostgres    false    219   �X       �          0    16464    ecrit 
   TABLE DATA           6   COPY public.ecrit ("unAuteur", "unLivre") FROM stdin;
    public          userpostgres    false    220   Y       �          0    16391    editeur 
   TABLE DATA           8   COPY public.editeur ("nomEditeur", adresse) FROM stdin;
    public          userpostgres    false    214   ,Y       �          0    16423 
   exemplaire 
   TABLE DATA           X   COPY public.exemplaire ("noExemplaire", "leLivre", "dateAchat", "leClient") FROM stdin;
    public          userpostgres    false    218   fY       �          0    16412    livre 
   TABLE DATA           Q   COPY public.livre ("noLivre", "typeLivre", titre, prix, "unEditeur") FROM stdin;
    public          userpostgres    false    217   �Y       �           0    0    auteur_noAuteur_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."auteur_noAuteur_seq"', 2, true);
          public          userpostgres    false    222            �           0    0    client_noClient_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."client_noClient_seq"', 1, true);
          public          userpostgres    false    223            �           0    0    exemplaire_noExemplaire_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."exemplaire_noExemplaire_seq"', 4, true);
          public          userpostgres    false    224            �           0    0    livre_noLivre_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public."livre_noLivre_seq"', 7, true);
          public          userpostgres    false    225            �           2606    16721    a_ecrit a_ecrit_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.a_ecrit
    ADD CONSTRAINT a_ecrit_pkey PRIMARY KEY ("unLivre", "unAuteur");
 >   ALTER TABLE ONLY public.a_ecrit DROP CONSTRAINT a_ecrit_pkey;
       public            userpostgres    false    221    221            �           2606    16453    auteur auteur_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.auteur
    ADD CONSTRAINT auteur_pkey PRIMARY KEY ("noAuteur");
 <   ALTER TABLE ONLY public.auteur DROP CONSTRAINT auteur_pkey;
       public            userpostgres    false    215            �           2606    16723    client client_emailClient_key 
   CONSTRAINT     c   ALTER TABLE ONLY public.client
    ADD CONSTRAINT "client_emailClient_key" UNIQUE ("emailClient");
 I   ALTER TABLE ONLY public.client DROP CONSTRAINT "client_emailClient_key";
       public            userpostgres    false    216            �           2606    16441    client client_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY ("noClient");
 <   ALTER TABLE ONLY public.client DROP CONSTRAINT client_pkey;
       public            userpostgres    false    216            �           2606    16395    editeur editeur_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.editeur
    ADD CONSTRAINT editeur_pkey PRIMARY KEY ("nomEditeur");
 >   ALTER TABLE ONLY public.editeur DROP CONSTRAINT editeur_pkey;
       public            userpostgres    false    214            �           2606    16427    exemplaire exemplaire_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.exemplaire
    ADD CONSTRAINT exemplaire_pkey PRIMARY KEY ("noExemplaire");
 D   ALTER TABLE ONLY public.exemplaire DROP CONSTRAINT exemplaire_pkey;
       public            userpostgres    false    218            �           2606    16416    livre livre_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.livre
    ADD CONSTRAINT livre_pkey PRIMARY KEY ("noLivre");
 :   ALTER TABLE ONLY public.livre DROP CONSTRAINT livre_pkey;
       public            userpostgres    false    217            �           2606    16463    contrat pkContrat 
   CONSTRAINT     f   ALTER TABLE ONLY public.contrat
    ADD CONSTRAINT "pkContrat" PRIMARY KEY ("unAuteur", "unEditeur");
 =   ALTER TABLE ONLY public.contrat DROP CONSTRAINT "pkContrat";
       public            userpostgres    false    219    219            �           2606    16468    ecrit pkEcrit 
   CONSTRAINT     `   ALTER TABLE ONLY public.ecrit
    ADD CONSTRAINT "pkEcrit" PRIMARY KEY ("unAuteur", "unLivre");
 9   ALTER TABLE ONLY public.ecrit DROP CONSTRAINT "pkEcrit";
       public            userpostgres    false    220    220            �           2606    16725    auteur uk_emailAuteur 
   CONSTRAINT     [   ALTER TABLE ONLY public.auteur
    ADD CONSTRAINT "uk_emailAuteur" UNIQUE ("emailAuteur");
 A   ALTER TABLE ONLY public.auteur DROP CONSTRAINT "uk_emailAuteur";
       public            userpostgres    false    215            �           2606    16404    auteur uqEmailAuteur 
   CONSTRAINT     Z   ALTER TABLE ONLY public.auteur
    ADD CONSTRAINT "uqEmailAuteur" UNIQUE ("emailAuteur");
 @   ALTER TABLE ONLY public.auteur DROP CONSTRAINT "uqEmailAuteur";
       public            userpostgres    false    215            �           2606    16411    client uqEmailClient 
   CONSTRAINT     Z   ALTER TABLE ONLY public.client
    ADD CONSTRAINT "uqEmailClient" UNIQUE ("emailClient");
 @   ALTER TABLE ONLY public.client DROP CONSTRAINT "uqEmailClient";
       public            userpostgres    false    216            �           1259    16439    fki_fkLeClient    INDEX     M   CREATE INDEX "fki_fkLeClient" ON public.exemplaire USING btree ("leClient");
 $   DROP INDEX public."fki_fkLeClient";
       public            userpostgres    false    218            �           1259    16433    fki_fkLeLivre    INDEX     K   CREATE INDEX "fki_fkLeLivre" ON public.exemplaire USING btree ("leLivre");
 #   DROP INDEX public."fki_fkLeLivre";
       public            userpostgres    false    218            �           1259    16496    fki_fkUnEditeur    INDEX     J   CREATE INDEX "fki_fkUnEditeur" ON public.livre USING btree ("unEditeur");
 %   DROP INDEX public."fki_fkUnEditeur";
       public            userpostgres    false    217            �           1259    16726    fki_fk_client    INDEX     J   CREATE INDEX fki_fk_client ON public.exemplaire USING btree ("leClient");
 !   DROP INDEX public.fki_fk_client;
       public            userpostgres    false    218            �           1259    16727    fki_fk_livre    INDEX     H   CREATE INDEX fki_fk_livre ON public.exemplaire USING btree ("leLivre");
     DROP INDEX public.fki_fk_livre;
       public            userpostgres    false    218                       2620    16798    livre LePrixChange    TRIGGER     �   CREATE TRIGGER "LePrixChange" BEFORE UPDATE OF prix ON public.livre FOR EACH ROW EXECUTE FUNCTION public."PrixDunLivreAugmente"();
 -   DROP TRIGGER "LePrixChange" ON public.livre;
       public          userpostgres    false    217    232    217            �           0    0    TRIGGER "LePrixChange" ON livre    COMMENT     H   COMMENT ON TRIGGER "LePrixChange" ON public.livre IS 'pas plus de 10%';
          public          userpostgres    false    3333            �           2606    16442    exemplaire fkLeClient    FK CONSTRAINT     �   ALTER TABLE ONLY public.exemplaire
    ADD CONSTRAINT "fkLeClient" FOREIGN KEY ("leClient") REFERENCES public.client("noClient") NOT VALID;
 A   ALTER TABLE ONLY public.exemplaire DROP CONSTRAINT "fkLeClient";
       public          userpostgres    false    3306    218    216            �           2606    16428    exemplaire fkLeLivre    FK CONSTRAINT     �   ALTER TABLE ONLY public.exemplaire
    ADD CONSTRAINT "fkLeLivre" FOREIGN KEY ("leLivre") REFERENCES public.livre("noLivre") NOT VALID;
 @   ALTER TABLE ONLY public.exemplaire DROP CONSTRAINT "fkLeLivre";
       public          userpostgres    false    218    3311    217            �           2606    16497    livre fkUnEditeur    FK CONSTRAINT     �   ALTER TABLE ONLY public.livre
    ADD CONSTRAINT "fkUnEditeur" FOREIGN KEY ("unEditeur") REFERENCES public.editeur("nomEditeur") NOT VALID;
 =   ALTER TABLE ONLY public.livre DROP CONSTRAINT "fkUnEditeur";
       public          userpostgres    false    214    217    3296                       2606    16728    contrat fk_auteur    FK CONSTRAINT     |   ALTER TABLE ONLY public.contrat
    ADD CONSTRAINT fk_auteur FOREIGN KEY ("unAuteur") REFERENCES public.auteur("noAuteur");
 ;   ALTER TABLE ONLY public.contrat DROP CONSTRAINT fk_auteur;
       public          userpostgres    false    215    3298    219                       2606    16733    a_ecrit fk_auteur    FK CONSTRAINT     |   ALTER TABLE ONLY public.a_ecrit
    ADD CONSTRAINT fk_auteur FOREIGN KEY ("unAuteur") REFERENCES public.auteur("noAuteur");
 ;   ALTER TABLE ONLY public.a_ecrit DROP CONSTRAINT fk_auteur;
       public          userpostgres    false    3298    215    221            �           2606    16738    exemplaire fk_client    FK CONSTRAINT     �   ALTER TABLE ONLY public.exemplaire
    ADD CONSTRAINT fk_client FOREIGN KEY ("leClient") REFERENCES public.client("noClient") NOT VALID;
 >   ALTER TABLE ONLY public.exemplaire DROP CONSTRAINT fk_client;
       public          userpostgres    false    216    218    3306                       2606    16743    contrat fk_editeur    FK CONSTRAINT     �   ALTER TABLE ONLY public.contrat
    ADD CONSTRAINT fk_editeur FOREIGN KEY ("unEditeur") REFERENCES public.editeur("nomEditeur");
 <   ALTER TABLE ONLY public.contrat DROP CONSTRAINT fk_editeur;
       public          userpostgres    false    3296    214    219                        2606    16748    exemplaire fk_livre    FK CONSTRAINT     �   ALTER TABLE ONLY public.exemplaire
    ADD CONSTRAINT fk_livre FOREIGN KEY ("leLivre") REFERENCES public.livre("noLivre") NOT VALID;
 =   ALTER TABLE ONLY public.exemplaire DROP CONSTRAINT fk_livre;
       public          userpostgres    false    218    3311    217                       2606    16753    a_ecrit fk_livre    FK CONSTRAINT     x   ALTER TABLE ONLY public.a_ecrit
    ADD CONSTRAINT fk_livre FOREIGN KEY ("unLivre") REFERENCES public.livre("noLivre");
 :   ALTER TABLE ONLY public.a_ecrit DROP CONSTRAINT fk_livre;
       public          userpostgres    false    3311    217    221            �      x�3�4�2�4����� G�      �   T   x�3��(��I�T 8sR�K��P�V��6�!=713G/9?��N �2��H-.N%B)PaQnb
3�
�2@���=... �6�      �   <   x�3��M�I-.��KU�8C22�KsJ�S�,�*�˅퐞�������KH3W� O��      �      x�3�t����W ���W���� ���      �      x������ � �      �   *   x�s����W 8�JSRRr�SS2KRK���\1z\\\ 9�o      �   #   x�3�4�4202�5��54�4�2�4G����� |�      �   J   x�3��w�p��IU��/-PHI-V(.I-(H-�4�3�t�����2C��M���I--����R�z�P�1z\\\ >�     