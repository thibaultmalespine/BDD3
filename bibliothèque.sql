PGDMP  9                    |           test    16.2    16.2 <    9           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            :           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            ;           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            <           1262    35279    test    DATABASE        CREATE DATABASE test WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE test;
                postgres    false            W           1247    35282    participant    TYPE     h   CREATE TYPE public.participant AS (
	nomequipe character varying(20),
	nomsite character varying(20)
);
    DROP TYPE public.participant;
       public          postgres    false            Z           1247    35285    student    TYPE     ]   CREATE TYPE public.student AS (
	nom character varying(20),
	prenom character varying(20)
);
    DROP TYPE public.student;
       public          postgres    false            �            1255    35286     obtenirTousLesExemplaireDe(text)    FUNCTION     H  CREATE FUNCTION public."obtenirTousLesExemplaireDe"("nomLivre" text) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $$DECLARE
exemplaire INT;

BEGIN
	FOR exemplaire IN 
		SELECT "noExemplaire" FROM livre, exemplaire
		WHERE "noLivre" = "leLivre" AND "titre" = "nomLivre"
		
	LOOP
		RETURN NEXT exemplaire;
	END LOOP;
END;$$;
 D   DROP FUNCTION public."obtenirTousLesExemplaireDe"("nomLivre" text);
       public          postgres    false            �            1259    35287 
   exemplaire    TABLE     �   CREATE TABLE public.exemplaire (
    "noExemplaire" integer NOT NULL,
    "leClient" integer,
    "leLivre" integer NOT NULL,
    "dateAchat" date DEFAULT now()
);
    DROP TABLE public.exemplaire;
       public         heap    postgres    false            �            1259    35291    livre    TABLE     �   CREATE TABLE public.livre (
    "noLivre" integer NOT NULL,
    "lEditeur" text,
    typelivre text,
    titre text,
    prix real
);
    DROP TABLE public.livre;
       public         heap    postgres    false            �            1259    35296 /   VérifierQueToutLesLivresEstAuMoinsUnExemplaire    VIEW     �   CREATE VIEW public."VérifierQueToutLesLivresEstAuMoinsUnExemplaire" AS
 SELECT livre."noLivre"
   FROM public.livre
EXCEPT
 SELECT exemplaire."leLivre" AS "noLivre"
   FROM public.exemplaire;
 D   DROP VIEW public."VérifierQueToutLesLivresEstAuMoinsUnExemplaire";
       public          postgres    false    217    218            �            1259    35300    a_ecrit    TABLE     a   CREATE TABLE public.a_ecrit (
    "unLivre" integer NOT NULL,
    "unAuteur" integer NOT NULL
);
    DROP TABLE public.a_ecrit;
       public         heap    postgres    false            �            1259    35303    auteur    TABLE     �   CREATE TABLE public.auteur (
    "noAuteur" integer NOT NULL,
    "nomAuteur" text,
    "prenomAuteur" text,
    "emailAuteur" text NOT NULL
);
    DROP TABLE public.auteur;
       public         heap    postgres    false            �            1259    35308    auteur_noAuteur_seq    SEQUENCE     �   CREATE SEQUENCE public."auteur_noAuteur_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."auteur_noAuteur_seq";
       public          postgres    false    221            =           0    0    auteur_noAuteur_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."auteur_noAuteur_seq" OWNED BY public.auteur."noAuteur";
          public          postgres    false    222            �            1259    35309    client    TABLE     �   CREATE TABLE public.client (
    "noClient" integer NOT NULL,
    "nomClient" text,
    "prenomClient" text,
    "emailClient" text NOT NULL
);
    DROP TABLE public.client;
       public         heap    postgres    false            �            1259    35314    client_noClient_seq    SEQUENCE     �   CREATE SEQUENCE public."client_noClient_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."client_noClient_seq";
       public          postgres    false    223            >           0    0    client_noClient_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."client_noClient_seq" OWNED BY public.client."noClient";
          public          postgres    false    224            �            1259    35315    contrat    TABLE     `   CREATE TABLE public.contrat (
    "unEditeur" text NOT NULL,
    "unAuteur" integer NOT NULL
);
    DROP TABLE public.contrat;
       public         heap    postgres    false            �            1259    35323    editeur    TABLE     [   CREATE TABLE public.editeur (
    "nomEditeur" text NOT NULL,
    adresse text NOT NULL
);
    DROP TABLE public.editeur;
       public         heap    postgres    false            �            1259    35334    exemplaire_noExemplaire_seq    SEQUENCE     �   CREATE SEQUENCE public."exemplaire_noExemplaire_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public."exemplaire_noExemplaire_seq";
       public          postgres    false    217            ?           0    0    exemplaire_noExemplaire_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."exemplaire_noExemplaire_seq" OWNED BY public.exemplaire."noExemplaire";
          public          postgres    false    227            �            1259    35335    idequipesequence    SEQUENCE     y   CREATE SEQUENCE public.idequipesequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.idequipesequence;
       public          postgres    false            �            1259    35336    livre_noLivre_seq    SEQUENCE     �   CREATE SEQUENCE public."livre_noLivre_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public."livre_noLivre_seq";
       public          postgres    false    218            @           0    0    livre_noLivre_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public."livre_noLivre_seq" OWNED BY public.livre."noLivre";
          public          postgres    false    229            |           2604    35344    auteur noAuteur    DEFAULT     v   ALTER TABLE ONLY public.auteur ALTER COLUMN "noAuteur" SET DEFAULT nextval('public."auteur_noAuteur_seq"'::regclass);
 @   ALTER TABLE public.auteur ALTER COLUMN "noAuteur" DROP DEFAULT;
       public          postgres    false    222    221            }           2604    35345    client noClient    DEFAULT     v   ALTER TABLE ONLY public.client ALTER COLUMN "noClient" SET DEFAULT nextval('public."client_noClient_seq"'::regclass);
 @   ALTER TABLE public.client ALTER COLUMN "noClient" DROP DEFAULT;
       public          postgres    false    224    223            y           2604    35346    exemplaire noExemplaire    DEFAULT     �   ALTER TABLE ONLY public.exemplaire ALTER COLUMN "noExemplaire" SET DEFAULT nextval('public."exemplaire_noExemplaire_seq"'::regclass);
 H   ALTER TABLE public.exemplaire ALTER COLUMN "noExemplaire" DROP DEFAULT;
       public          postgres    false    227    217            {           2604    35347    livre noLivre    DEFAULT     r   ALTER TABLE ONLY public.livre ALTER COLUMN "noLivre" SET DEFAULT nextval('public."livre_noLivre_seq"'::regclass);
 >   ALTER TABLE public.livre ALTER COLUMN "noLivre" DROP DEFAULT;
       public          postgres    false    229    218            -          0    35300    a_ecrit 
   TABLE DATA           8   COPY public.a_ecrit ("unLivre", "unAuteur") FROM stdin;
    public          postgres    false    220   �C       .          0    35303    auteur 
   TABLE DATA           X   COPY public.auteur ("noAuteur", "nomAuteur", "prenomAuteur", "emailAuteur") FROM stdin;
    public          postgres    false    221   	D       0          0    35309    client 
   TABLE DATA           X   COPY public.client ("noClient", "nomClient", "prenomClient", "emailClient") FROM stdin;
    public          postgres    false    223   �D       2          0    35315    contrat 
   TABLE DATA           :   COPY public.contrat ("unEditeur", "unAuteur") FROM stdin;
    public          postgres    false    225   /E       3          0    35323    editeur 
   TABLE DATA           8   COPY public.editeur ("nomEditeur", adresse) FROM stdin;
    public          postgres    false    226   LE       +          0    35287 
   exemplaire 
   TABLE DATA           X   COPY public.exemplaire ("noExemplaire", "leClient", "leLivre", "dateAchat") FROM stdin;
    public          postgres    false    217   �E       ,          0    35291    livre 
   TABLE DATA           N   COPY public.livre ("noLivre", "lEditeur", typelivre, titre, prix) FROM stdin;
    public          postgres    false    218   !F       A           0    0    auteur_noAuteur_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."auteur_noAuteur_seq"', 8, true);
          public          postgres    false    222            B           0    0    client_noClient_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."client_noClient_seq"', 1, true);
          public          postgres    false    224            C           0    0    exemplaire_noExemplaire_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public."exemplaire_noExemplaire_seq"', 12, true);
          public          postgres    false    227            D           0    0    idequipesequence    SEQUENCE SET     >   SELECT pg_catalog.setval('public.idequipesequence', 5, true);
          public          postgres    false    228            E           0    0    livre_noLivre_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."livre_noLivre_seq"', 24, true);
          public          postgres    false    229            �           2606    35349    a_ecrit a_ecrit_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.a_ecrit
    ADD CONSTRAINT a_ecrit_pkey PRIMARY KEY ("unLivre", "unAuteur");
 >   ALTER TABLE ONLY public.a_ecrit DROP CONSTRAINT a_ecrit_pkey;
       public            postgres    false    220    220            �           2606    35351    auteur auteur_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.auteur
    ADD CONSTRAINT auteur_pkey PRIMARY KEY ("noAuteur");
 <   ALTER TABLE ONLY public.auteur DROP CONSTRAINT auteur_pkey;
       public            postgres    false    221            ~           2606    35352    livre check_typelivre    CHECK CONSTRAINT     �   ALTER TABLE public.livre
    ADD CONSTRAINT check_typelivre CHECK (((typelivre = 'BD'::text) OR (typelivre = 'POCHE'::text))) NOT VALID;
 :   ALTER TABLE public.livre DROP CONSTRAINT check_typelivre;
       public          postgres    false    218    218            �           2606    35354    client client_emailClient_key 
   CONSTRAINT     c   ALTER TABLE ONLY public.client
    ADD CONSTRAINT "client_emailClient_key" UNIQUE ("emailClient");
 I   ALTER TABLE ONLY public.client DROP CONSTRAINT "client_emailClient_key";
       public            postgres    false    223            �           2606    35356    client client_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY ("noClient");
 <   ALTER TABLE ONLY public.client DROP CONSTRAINT client_pkey;
       public            postgres    false    223            �           2606    35358    contrat contrat_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.contrat
    ADD CONSTRAINT contrat_pkey PRIMARY KEY ("unEditeur", "unAuteur");
 >   ALTER TABLE ONLY public.contrat DROP CONSTRAINT contrat_pkey;
       public            postgres    false    225    225            �           2606    35360    editeur editeur_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.editeur
    ADD CONSTRAINT editeur_pkey PRIMARY KEY ("nomEditeur");
 >   ALTER TABLE ONLY public.editeur DROP CONSTRAINT editeur_pkey;
       public            postgres    false    226            �           2606    35362    exemplaire exemplaire_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.exemplaire
    ADD CONSTRAINT exemplaire_pkey PRIMARY KEY ("noExemplaire");
 D   ALTER TABLE ONLY public.exemplaire DROP CONSTRAINT exemplaire_pkey;
       public            postgres    false    217            �           2606    35364    livre livre_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.livre
    ADD CONSTRAINT livre_pkey PRIMARY KEY ("noLivre");
 :   ALTER TABLE ONLY public.livre DROP CONSTRAINT livre_pkey;
       public            postgres    false    218            �           2606    35376    auteur uk_emailAuteur 
   CONSTRAINT     [   ALTER TABLE ONLY public.auteur
    ADD CONSTRAINT "uk_emailAuteur" UNIQUE ("emailAuteur");
 A   ALTER TABLE ONLY public.auteur DROP CONSTRAINT "uk_emailAuteur";
       public            postgres    false    221            �           1259    35377    fki_fk_client    INDEX     J   CREATE INDEX fki_fk_client ON public.exemplaire USING btree ("leClient");
 !   DROP INDEX public.fki_fk_client;
       public            postgres    false    217            �           1259    35378    fki_fk_editeur    INDEX     F   CREATE INDEX fki_fk_editeur ON public.livre USING btree ("lEditeur");
 "   DROP INDEX public.fki_fk_editeur;
       public            postgres    false    218            �           1259    35379    fki_fk_livre    INDEX     H   CREATE INDEX fki_fk_livre ON public.exemplaire USING btree ("leLivre");
     DROP INDEX public.fki_fk_livre;
       public            postgres    false    217            �           2606    35380    contrat fk_auteur    FK CONSTRAINT     |   ALTER TABLE ONLY public.contrat
    ADD CONSTRAINT fk_auteur FOREIGN KEY ("unAuteur") REFERENCES public.auteur("noAuteur");
 ;   ALTER TABLE ONLY public.contrat DROP CONSTRAINT fk_auteur;
       public          postgres    false    4745    225    221            �           2606    35385    a_ecrit fk_auteur    FK CONSTRAINT     |   ALTER TABLE ONLY public.a_ecrit
    ADD CONSTRAINT fk_auteur FOREIGN KEY ("unAuteur") REFERENCES public.auteur("noAuteur");
 ;   ALTER TABLE ONLY public.a_ecrit DROP CONSTRAINT fk_auteur;
       public          postgres    false    221    4745    220            �           2606    35390    exemplaire fk_client    FK CONSTRAINT     �   ALTER TABLE ONLY public.exemplaire
    ADD CONSTRAINT fk_client FOREIGN KEY ("leClient") REFERENCES public.client("noClient") NOT VALID;
 >   ALTER TABLE ONLY public.exemplaire DROP CONSTRAINT fk_client;
       public          postgres    false    217    223    4751            �           2606    35395    contrat fk_editeur    FK CONSTRAINT     �   ALTER TABLE ONLY public.contrat
    ADD CONSTRAINT fk_editeur FOREIGN KEY ("unEditeur") REFERENCES public.editeur("nomEditeur");
 <   ALTER TABLE ONLY public.contrat DROP CONSTRAINT fk_editeur;
       public          postgres    false    225    4755    226            �           2606    35400    livre fk_editeur    FK CONSTRAINT     �   ALTER TABLE ONLY public.livre
    ADD CONSTRAINT fk_editeur FOREIGN KEY ("lEditeur") REFERENCES public.editeur("nomEditeur") NOT VALID;
 :   ALTER TABLE ONLY public.livre DROP CONSTRAINT fk_editeur;
       public          postgres    false    226    218    4755            �           2606    35405    exemplaire fk_livre    FK CONSTRAINT     �   ALTER TABLE ONLY public.exemplaire
    ADD CONSTRAINT fk_livre FOREIGN KEY ("leLivre") REFERENCES public.livre("noLivre") NOT VALID;
 =   ALTER TABLE ONLY public.exemplaire DROP CONSTRAINT fk_livre;
       public          postgres    false    217    4741    218            �           2606    35410    a_ecrit fk_livre    FK CONSTRAINT     x   ALTER TABLE ONLY public.a_ecrit
    ADD CONSTRAINT fk_livre FOREIGN KEY ("unLivre") REFERENCES public.livre("noLivre");
 :   ALTER TABLE ONLY public.a_ecrit DROP CONSTRAINT fk_livre;
       public          postgres    false    220    4741    218            -   3   x��9   �:'�!����m�>2�
^�x���hk��K�i��<Ԑl      .   �   x�M�Kn�@D��Sp���2���@H%�l�c�2�F�1�#����̠�ԓ^UuacOd,HlN���y���Tʤ!W,�P̝1��s�.�oa|����TN������&-�a�ʺ��ٓuغh5���O:V��Z2�W�g�G�8�YV��m��Nivo�s}h��cv��������0�:U�q��iA������$�!_�]      0   3   x�3��M�I-.��K���LJ,�)�,�2�rar鹉�9z���\1z\\\ &z�      2      x������ � �      3   j   x�sJLJ��43�53�QH,K�+MUHIUN�H�
ʘ*E��K��t�sr2s�R�|R|2ˊ���3R9��J}��J
����S���s2�q����� h�)      +   K   x�U̹�0�X�E�����밑A����E����Ց�W��`�,6CeS�r�:*E)8i]Ҿ(xJ�cf�      ,   �   x�u��N�0���S�Ɖ��]�^W@&QiH\�d�˂�fr�	����H M�$n����g��;k������>�������	o��Z�B��|��H>4���ѵ91ᎰwÞ�+<n\�DR���Fq"|&��-e-T;ۭڦ�6�7�̑���d:�C-Q�K힂	سI��H�b���\�'����(��_f�D�Zb���8U�T+�=����ϩ�E�M
�x�B�o6�o�     