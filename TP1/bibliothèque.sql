PGDMP      .                |           tp1_user    16.2    16.2 ?    >           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            ?           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            @           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            A           1262    35550    tp1_user    DATABASE     �   CREATE DATABASE tp1_user WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE tp1_user;
                thiba    false            �            1255    35790    auteurPréféréDe(integer)    FUNCTION     ?  CREATE FUNCTION public."auteurPréféréDe"("numClient" integer) RETURNS record
    LANGUAGE plpgsql
    AS $$BEGIN
-- RETOURNE LE NOM COMPLET DE L'AUTEUR
RETURN ("noAuteur","nomAuteur","prenomAuteur") FROM auteur WHERE "noAuteur" IN (
	-- Compter le nombre de livre appartenant au même auteur
	SELECT "unAuteur" FROM a_ecrit, (
		-- Récupère tous les exemplaires que le client possède
		SELECT * FROM exemplaire WHERE "numClient" = "leClient"
	) AS exemplairesClient 
	WHERE "unLivre" = "leLivre" GROUP BY ("unAuteur") ORDER BY COUNT("unAuteur") DESC LIMIT 1
);
END;$$;
 @   DROP FUNCTION public."auteurPréféréDe"("numClient" integer);
       public          postgres    false            �            1255    35557     obtenirTousLesExemplaireDe(text)    FUNCTION     Q  CREATE FUNCTION public."obtenirTousLesExemplaireDe"("nomLivre" text) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $$DECLARE
exemplaire INT;

BEGIN
	FOR exemplaire IN 
		SELECT "noLivre" FROM livre, exemplaire
		WHERE "noLivre" = "leLivre" AND UPPER("titre") = UPPER("nomLivre")
		
	LOOP
		RETURN NEXT exemplaire;
	END LOOP;
END;$$;
 D   DROP FUNCTION public."obtenirTousLesExemplaireDe"("nomLivre" text);
       public          thiba    false            �            1255    35803    prixLivre()    FUNCTION       CREATE FUNCTION public."prixLivre"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
IF OLD.prix * 1.1 >= NEW.prix THEN
	RETURN NEW;
ELSE
	RAISE EXCEPTION 'Mise à jour interdite : le prix d''un livre ne peut pas augmenter de plus de 10%% .';
END IF;
END
	$$;
 $   DROP FUNCTION public."prixLivre"();
       public          postgres    false            �            1259    35571    a_ecrit    TABLE     a   CREATE TABLE public.a_ecrit (
    "unLivre" integer NOT NULL,
    "unAuteur" integer NOT NULL
);
    DROP TABLE public.a_ecrit;
       public         heap    thiba    false            �            1259    35574    auteur    TABLE     �   CREATE TABLE public.auteur (
    "noAuteur" integer NOT NULL,
    "nomAuteur" text,
    "prenomAuteur" text,
    "emailAuteur" text NOT NULL
);
    DROP TABLE public.auteur;
       public         heap    thiba    false            �            1259    35579    auteur_noAuteur_seq    SEQUENCE     �   CREATE SEQUENCE public."auteur_noAuteur_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."auteur_noAuteur_seq";
       public          thiba    false    218            B           0    0    auteur_noAuteur_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."auteur_noAuteur_seq" OWNED BY public.auteur."noAuteur";
          public          thiba    false    219            �            1259    35580    client    TABLE     �   CREATE TABLE public.client (
    "noClient" integer NOT NULL,
    "nomClient" text,
    "prenomClient" text,
    "emailClient" text NOT NULL
);
    DROP TABLE public.client;
       public         heap    thiba    false            �            1259    35585    client_noClient_seq    SEQUENCE     �   CREATE SEQUENCE public."client_noClient_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."client_noClient_seq";
       public          thiba    false    220            C           0    0    client_noClient_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."client_noClient_seq" OWNED BY public.client."noClient";
          public          thiba    false    221            �            1259    35586    contrat    TABLE     `   CREATE TABLE public.contrat (
    "unEditeur" text NOT NULL,
    "unAuteur" integer NOT NULL
);
    DROP TABLE public.contrat;
       public         heap    thiba    false            �            1259    35591    editeur    TABLE     [   CREATE TABLE public.editeur (
    "nomEditeur" text NOT NULL,
    adresse text NOT NULL
);
    DROP TABLE public.editeur;
       public         heap    thiba    false            �            1259    35558 
   exemplaire    TABLE     �   CREATE TABLE public.exemplaire (
    "noExemplaire" integer NOT NULL,
    "leClient" integer,
    "leLivre" integer NOT NULL,
    "dateAchat" date DEFAULT now()
);
    DROP TABLE public.exemplaire;
       public         heap    thiba    false            �            1259    35596    exemplaire_noExemplaire_seq    SEQUENCE     �   CREATE SEQUENCE public."exemplaire_noExemplaire_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public."exemplaire_noExemplaire_seq";
       public          thiba    false    215            D           0    0    exemplaire_noExemplaire_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."exemplaire_noExemplaire_seq" OWNED BY public.exemplaire."noExemplaire";
          public          thiba    false    224            �            1259    35597    idequipesequence    SEQUENCE     y   CREATE SEQUENCE public.idequipesequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.idequipesequence;
       public          postgres    false            �            1259    35799 %   listeDesAuteursQuiNontPasEcritDeLivre    VIEW     �   CREATE VIEW public."listeDesAuteursQuiNontPasEcritDeLivre" AS
 SELECT "noAuteur",
    "nomAuteur",
    "prenomAuteur",
    "emailAuteur"
   FROM public.auteur
  WHERE (NOT ("noAuteur" IN ( SELECT a_ecrit."unAuteur"
           FROM public.a_ecrit)));
 :   DROP VIEW public."listeDesAuteursQuiNontPasEcritDeLivre";
       public          postgres    false    218    218    218    217    218            �            1259    35562    livre    TABLE     �   CREATE TABLE public.livre (
    "noLivre" integer NOT NULL,
    "lEditeur" text,
    typelivre text,
    titre text,
    prix real
);
    DROP TABLE public.livre;
       public         heap    thiba    false            �            1259    35795 ,   listeDesLivresQuiNontEtaientEcritParPersonne    VIEW       CREATE VIEW public."listeDesLivresQuiNontEtaientEcritParPersonne" AS
 SELECT livre."noLivre",
    livre.titre
   FROM public.livre
EXCEPT
 SELECT a_ecrit."unLivre" AS "noLivre",
    livre.titre
   FROM public.a_ecrit,
    public.livre
  WHERE (a_ecrit."unLivre" = livre."noLivre");
 A   DROP VIEW public."listeDesLivresQuiNontEtaientEcritParPersonne";
       public          postgres    false    216    217    216            �            1259    35791 #   listeDesLivresQuiNontPasDexemplaire    VIEW     �   CREATE VIEW public."listeDesLivresQuiNontPasDexemplaire" AS
 SELECT "noLivre",
    "lEditeur",
    typelivre,
    titre,
    prix
   FROM public.livre
  WHERE (NOT ("noLivre" IN ( SELECT exemplaire."leLivre"
           FROM public.exemplaire)));
 8   DROP VIEW public."listeDesLivresQuiNontPasDexemplaire";
       public          thiba    false    216    216    216    216    216    215            �            1259    35598    livre_noLivre_seq    SEQUENCE     �   CREATE SEQUENCE public."livre_noLivre_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public."livre_noLivre_seq";
       public          thiba    false    216            E           0    0    livre_noLivre_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public."livre_noLivre_seq" OWNED BY public.livre."noLivre";
          public          thiba    false    226            ~           2604    35599    auteur noAuteur    DEFAULT     v   ALTER TABLE ONLY public.auteur ALTER COLUMN "noAuteur" SET DEFAULT nextval('public."auteur_noAuteur_seq"'::regclass);
 @   ALTER TABLE public.auteur ALTER COLUMN "noAuteur" DROP DEFAULT;
       public          thiba    false    219    218                       2604    35600    client noClient    DEFAULT     v   ALTER TABLE ONLY public.client ALTER COLUMN "noClient" SET DEFAULT nextval('public."client_noClient_seq"'::regclass);
 @   ALTER TABLE public.client ALTER COLUMN "noClient" DROP DEFAULT;
       public          thiba    false    221    220            {           2604    35601    exemplaire noExemplaire    DEFAULT     �   ALTER TABLE ONLY public.exemplaire ALTER COLUMN "noExemplaire" SET DEFAULT nextval('public."exemplaire_noExemplaire_seq"'::regclass);
 H   ALTER TABLE public.exemplaire ALTER COLUMN "noExemplaire" DROP DEFAULT;
       public          thiba    false    224    215            }           2604    35602    livre noLivre    DEFAULT     r   ALTER TABLE ONLY public.livre ALTER COLUMN "noLivre" SET DEFAULT nextval('public."livre_noLivre_seq"'::regclass);
 >   ALTER TABLE public.livre ALTER COLUMN "noLivre" DROP DEFAULT;
       public          thiba    false    226    216            2          0    35571    a_ecrit 
   TABLE DATA           8   COPY public.a_ecrit ("unLivre", "unAuteur") FROM stdin;
    public          thiba    false    217   �K       3          0    35574    auteur 
   TABLE DATA           X   COPY public.auteur ("noAuteur", "nomAuteur", "prenomAuteur", "emailAuteur") FROM stdin;
    public          thiba    false    218   FL       5          0    35580    client 
   TABLE DATA           X   COPY public.client ("noClient", "nomClient", "prenomClient", "emailClient") FROM stdin;
    public          thiba    false    220   )M       7          0    35586    contrat 
   TABLE DATA           :   COPY public.contrat ("unEditeur", "unAuteur") FROM stdin;
    public          thiba    false    222   lM       8          0    35591    editeur 
   TABLE DATA           8   COPY public.editeur ("nomEditeur", adresse) FROM stdin;
    public          thiba    false    223   �M       0          0    35558 
   exemplaire 
   TABLE DATA           X   COPY public.exemplaire ("noExemplaire", "leClient", "leLivre", "dateAchat") FROM stdin;
    public          thiba    false    215   N       1          0    35562    livre 
   TABLE DATA           N   COPY public.livre ("noLivre", "lEditeur", typelivre, titre, prix) FROM stdin;
    public          thiba    false    216   |N       F           0    0    auteur_noAuteur_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."auteur_noAuteur_seq"', 8, true);
          public          thiba    false    219            G           0    0    client_noClient_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."client_noClient_seq"', 1, true);
          public          thiba    false    221            H           0    0    exemplaire_noExemplaire_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public."exemplaire_noExemplaire_seq"', 13, true);
          public          thiba    false    224            I           0    0    idequipesequence    SEQUENCE SET     >   SELECT pg_catalog.setval('public.idequipesequence', 5, true);
          public          postgres    false    225            J           0    0    livre_noLivre_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."livre_noLivre_seq"', 26, true);
          public          thiba    false    226            �           2606    35604    a_ecrit a_ecrit_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.a_ecrit
    ADD CONSTRAINT a_ecrit_pkey PRIMARY KEY ("unLivre", "unAuteur");
 >   ALTER TABLE ONLY public.a_ecrit DROP CONSTRAINT a_ecrit_pkey;
       public            thiba    false    217    217            �           2606    35606    auteur auteur_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.auteur
    ADD CONSTRAINT auteur_pkey PRIMARY KEY ("noAuteur");
 <   ALTER TABLE ONLY public.auteur DROP CONSTRAINT auteur_pkey;
       public            thiba    false    218            �           2606    35607    livre check_typelivre    CHECK CONSTRAINT     �   ALTER TABLE public.livre
    ADD CONSTRAINT check_typelivre CHECK (((typelivre = 'BD'::text) OR (typelivre = 'POCHE'::text))) NOT VALID;
 :   ALTER TABLE public.livre DROP CONSTRAINT check_typelivre;
       public          thiba    false    216    216            �           2606    35609    client client_emailClient_key 
   CONSTRAINT     c   ALTER TABLE ONLY public.client
    ADD CONSTRAINT "client_emailClient_key" UNIQUE ("emailClient");
 I   ALTER TABLE ONLY public.client DROP CONSTRAINT "client_emailClient_key";
       public            thiba    false    220            �           2606    35611    client client_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY ("noClient");
 <   ALTER TABLE ONLY public.client DROP CONSTRAINT client_pkey;
       public            thiba    false    220            �           2606    35613    contrat contrat_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.contrat
    ADD CONSTRAINT contrat_pkey PRIMARY KEY ("unEditeur", "unAuteur");
 >   ALTER TABLE ONLY public.contrat DROP CONSTRAINT contrat_pkey;
       public            thiba    false    222    222            �           2606    35615    editeur editeur_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.editeur
    ADD CONSTRAINT editeur_pkey PRIMARY KEY ("nomEditeur");
 >   ALTER TABLE ONLY public.editeur DROP CONSTRAINT editeur_pkey;
       public            thiba    false    223            �           2606    35617    exemplaire exemplaire_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.exemplaire
    ADD CONSTRAINT exemplaire_pkey PRIMARY KEY ("noExemplaire");
 D   ALTER TABLE ONLY public.exemplaire DROP CONSTRAINT exemplaire_pkey;
       public            thiba    false    215            �           2606    35619    livre livre_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.livre
    ADD CONSTRAINT livre_pkey PRIMARY KEY ("noLivre");
 :   ALTER TABLE ONLY public.livre DROP CONSTRAINT livre_pkey;
       public            thiba    false    216            �           2606    35621    auteur uk_emailAuteur 
   CONSTRAINT     [   ALTER TABLE ONLY public.auteur
    ADD CONSTRAINT "uk_emailAuteur" UNIQUE ("emailAuteur");
 A   ALTER TABLE ONLY public.auteur DROP CONSTRAINT "uk_emailAuteur";
       public            thiba    false    218            �           1259    35622    fki_fk_client    INDEX     J   CREATE INDEX fki_fk_client ON public.exemplaire USING btree ("leClient");
 !   DROP INDEX public.fki_fk_client;
       public            thiba    false    215            �           1259    35623    fki_fk_editeur    INDEX     F   CREATE INDEX fki_fk_editeur ON public.livre USING btree ("lEditeur");
 "   DROP INDEX public.fki_fk_editeur;
       public            thiba    false    216            �           1259    35624    fki_fk_livre    INDEX     H   CREATE INDEX fki_fk_livre ON public.exemplaire USING btree ("leLivre");
     DROP INDEX public.fki_fk_livre;
       public            thiba    false    215            �           2620    35804 1   livre lePrixDunLivreNePeuxPasAugmenterDePlusDe10%    TRIGGER     �   CREATE TRIGGER "lePrixDunLivreNePeuxPasAugmenterDePlusDe10%" BEFORE UPDATE OF prix ON public.livre FOR EACH ROW EXECUTE FUNCTION public."prixLivre"();
 L   DROP TRIGGER "lePrixDunLivreNePeuxPasAugmenterDePlusDe10%" ON public.livre;
       public          thiba    false    216    216    231            �           2606    35625    contrat fk_auteur    FK CONSTRAINT     |   ALTER TABLE ONLY public.contrat
    ADD CONSTRAINT fk_auteur FOREIGN KEY ("unAuteur") REFERENCES public.auteur("noAuteur");
 ;   ALTER TABLE ONLY public.contrat DROP CONSTRAINT fk_auteur;
       public          thiba    false    222    218    4747            �           2606    35630    a_ecrit fk_auteur    FK CONSTRAINT     |   ALTER TABLE ONLY public.a_ecrit
    ADD CONSTRAINT fk_auteur FOREIGN KEY ("unAuteur") REFERENCES public.auteur("noAuteur");
 ;   ALTER TABLE ONLY public.a_ecrit DROP CONSTRAINT fk_auteur;
       public          thiba    false    217    218    4747            �           2606    35635    exemplaire fk_client    FK CONSTRAINT     �   ALTER TABLE ONLY public.exemplaire
    ADD CONSTRAINT fk_client FOREIGN KEY ("leClient") REFERENCES public.client("noClient") NOT VALID;
 >   ALTER TABLE ONLY public.exemplaire DROP CONSTRAINT fk_client;
       public          thiba    false    215    4753    220            �           2606    35640    contrat fk_editeur    FK CONSTRAINT     �   ALTER TABLE ONLY public.contrat
    ADD CONSTRAINT fk_editeur FOREIGN KEY ("unEditeur") REFERENCES public.editeur("nomEditeur");
 <   ALTER TABLE ONLY public.contrat DROP CONSTRAINT fk_editeur;
       public          thiba    false    222    223    4757            �           2606    35645    livre fk_editeur    FK CONSTRAINT     �   ALTER TABLE ONLY public.livre
    ADD CONSTRAINT fk_editeur FOREIGN KEY ("lEditeur") REFERENCES public.editeur("nomEditeur") NOT VALID;
 :   ALTER TABLE ONLY public.livre DROP CONSTRAINT fk_editeur;
       public          thiba    false    216    223    4757            �           2606    35650    exemplaire fk_livre    FK CONSTRAINT     �   ALTER TABLE ONLY public.exemplaire
    ADD CONSTRAINT fk_livre FOREIGN KEY ("leLivre") REFERENCES public.livre("noLivre") NOT VALID;
 =   ALTER TABLE ONLY public.exemplaire DROP CONSTRAINT fk_livre;
       public          thiba    false    4743    216    215            �           2606    35655    a_ecrit fk_livre    FK CONSTRAINT     x   ALTER TABLE ONLY public.a_ecrit
    ADD CONSTRAINT fk_livre FOREIGN KEY ("unLivre") REFERENCES public.livre("noLivre");
 :   ALTER TABLE ONLY public.a_ecrit DROP CONSTRAINT fk_livre;
       public          thiba    false    217    4743    216            2   8   x���� ����8H/鿎�o�Y�2�
>Z�4��JT�:d���M�.���~�.      3   �   x�M�Kn�@D��Sp���2���@H%�l�c�2�F�1�#����̠�ԓ^UuacOd,HlN���y���Tʤ!W,�P̝1��s�.�oa|����TN������&-�a�ʺ��ٓuغh5���O:V��Z2�W�g�G�8�YV��m��Nivo�s}h��cv��������0�:U�q��iA������$�!_�]      5   3   x�3��M�I-.��K���LJ,�)�,�2�rar鹉�9z���\1z\\\ &z�      7      x������ � �      8   �   x�sJLJ��43�53�QH,K�+MUHIUN�H�
ʘ*E��K��t�sr2s�R�|R|2ˊ���3R9��J}��J
����S���s2�q��rxej1���XAJ�B@fzj~^^fjW� �"3;      0   O   x�U��� C�37����Ht��o�Æ�p��z��$DY�/�X
�`�c9�˅\SP52�n�8�F���}D�m�!      1     x�u�AN�0E��SxǊ;i�l@ U"R�ذq�	5J�hlW�H=G/������<O���ã鵁��zz�5�{��=�dby>R|B��$e���Z�	y��6�O+,��u��&�[�?я�ߐ�	�$g�<�-�"�2ɘ���쐆�a�����I���Ԯ�i�k�!��W�9����B�@RM�Z0��+����u�#qt|�&Y�2X�퉋u+E#����x{kMr&sxn�����n�����bk�8oss<�`�`��	c�bZ|@     