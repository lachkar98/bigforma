
Drop table TraductionMots;
DROP TABLE synonymesMots;

CREATE TABLE TraductionMots (
    ID VARCHAR(50),
    MotOriginal VARCHAR2(255),
    MotTraduit VARCHAR2(255)
);

CREATE TABLE SynonymesMots (
    ID VARCHAR2(50),
    MotOriginal VARCHAR2(255),
    Synonyme VARCHAR2(255)
);



select * from TraductionMots;
select * from SynonymesMots;

select count(*) from TraductionMots;