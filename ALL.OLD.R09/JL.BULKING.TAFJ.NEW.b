*-----------------------------------------------------------------------------
* <Rating>148</Rating>
*-----------------------------------------------------------------------------
    PROGRAM JL.BULKING.TAFJ.NEW
    $INSERT GLOBUS.BP I_COMMON
    $INSERT GLOBUS.BP I_EQUATE
    $INSERT GLOBUS.BP I_BATCH.FILES
    $INSERT GLOBUS.BP I_F.PGM.FILE


    HUSH ON
    CALL T24.INITIALISE
    HUSH OFF

    CRT "********************************************************************************************************"
    CRT " This routine is used to split / bulk a JOB.LIST file. To split a JOB.LIST, Input the Bulking No. as 1 "
    CRT "********************************************************************************************************"
    CRT "Input the JOB.LIST to bulk, example F.JOB.LIST.6"
    INPUT LIST.NAME
    CRT "Input the Bulking No, say 50"
    INPUT Y.BULK.NO

    FN.LIST=LIST.NAME
    FV.LIST=''
    CALL OPF(FN.LIST,FV.LIST)

    FN.LIST.BK="TEST.FILE"
    FV.LIST.BK=""

    EXECUTE "CREATE-FILE TEST.FILE TYPE=UD" CAPTURING OUT2
    EXECUTE "CLEAR.FILE ":FN.LIST.BK
    OPEN FN.LIST.BK TO FV.LIST.BK ELSE
        CRT "CAN NOT OPEN FILE"
    END

    EXECUTE "COPY FROM ":FN.LIST:" TO ":FN.LIST.BK:" ALL" CAPTURING OUT.EXE2

    GOSUB BACKUP.CHECK;



    IF PROCEED.FURTHER THEN
        EXECUTE "CLEAR.FILE ":FN.LIST
        SEL.CMD='SELECT ' : FN.LIST.BK
        LIST.KEY=''
        TEMP.KEY=''
        TOTAL.TEM.KEY=''
        Y.POS=''
        X=''
        CALL EB.READLIST(SEL.CMD, FULL.LIST, '', NUMBER.OF.KEYS, '')

        CRT "*******BEFORE BULKING*******"
        CRT "COUNT":LIST.NAME:": ":NUMBER.OF.KEYS

        CRT "BULKING IN PROGRESS........"
        LOOP
            REMOVE KEY1 FROM FULL.LIST SETTING YDELIM WHILE KEY1:YDELIM
            READ LIST.RECORD FROM FV.LIST.BK, KEY1 THEN
                NO.OF.LIST.KEYS = DCOUNT(LIST.RECORD,FM)
                FOR LIDX = 1 TO NO.OF.LIST.KEYS   ;*Loop through one by one
                    Y.TEMP.LIST = ''
                    Y.TEMP.LIST = LIST.RECORD<LIDX>

                    NO.OF.TEM.KEYS = DCOUNT(Y.TEMP.LIST,FM)
                    LIST.KEY=TEMP.KEY
                    FOR J = 1 TO NO.OF.TEM.KEYS
                        LIST.KEY +=1
                        WRITE Y.TEMP.LIST<1,J> TO FV.LIST, LIST.KEY
                    NEXT J
                    TEMP.KEY=LIST.KEY
                    TOTAL.TEM.KEY+=TEMP.KEY
                NEXT LIDX
            END ELSE
                NULL
            END
        REPEAT
    END


    GOSUB CNT.LIST.ORIG

    IF TEMP.KEY EQ COUNT.LIST.ORIG THEN
        CRT "*******BULKING COMPLETED*******"
        CRT "TOTAL CONTRACTS:":COUNT.LIST.ORIG
    END ELSE

        CRT "*******UNBULKING INCOMPLETE,PLEASE RE-RUN THE ROUTINE*******"
        EXECUTE "CLEAR.FILE ":FN.LIST
        EXECUTE "COPY FROM ":FN.LIST.BK:" TO ":FN.LIST:" ALL"

    END
    RETURN

BACKUP.CHECK:
*============*

    GOSUB CNT.LIST.ORIG

    GOSUB CNT.LIST.BK


    IF COUNT.LIST.BK EQ COUNT.LIST.ORIG THEN
        PROCEED.FURTHER=1;
    END ELSE
        PROCEED.FURTHER=0;
    END
    PROCEED.FURTHER=1;
    RETURN

CNT.LIST.ORIG:
*============*
    SEL.CMD.ORIG='SELECT ':FN.LIST
    ID.LIST.ORIG=''
    CALL EB.READLIST(SEL.CMD.ORIG, FULL.LIST.ORIG, '', NUMBER.OF.KEYS.ORIG, '')
    COUNT.LIST.ORIG = ''
    CNT.ORG = ''
    LOOP
        REMOVE ORG.ID FROM FULL.LIST.ORIG SETTING POS.ORG
    WHILE ORG.ID:POS.ORG

        READ ORG.REC FROM FV.LIST, ORG.ID THEN
            CNT.ORG = DCOUNT(ORG.REC,@FM)

            IF CNT.ORG THEN
                COUNT.LIST.ORIG = COUNT.LIST.ORIG + CNT.ORG
            END ELSE
                COUNT.LIST.ORIG = COUNT.LIST.ORIG + 1
            END
        END
    REPEAT

    RETURN

CNT.LIST.BK:
*============*

    COUNT.LIST.BK = ''
    CNT.BK = ''

    EXECUTE "SELECT ":FN.LIST.BK CAPTURING EXEC.OUT
    ID.LIST.BK=''

    LOOP
        READNEXT BK.ID ELSE BK.ID = ""
    WHILE BK.ID

        READ BK.REC FROM FV.LIST.BK, BK.ID THEN
            CNT.BK = DCOUNT(BK.REC,@FM)

            IF CNT.BK THEN
                COUNT.LIST.BK = COUNT.LIST.BK + CNT.BK
            END ELSE
                COUNT.LIST.BK = COUNT.LIST.BK + 1
            END
        END
    REPEAT

    RETURN


END 
