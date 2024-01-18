*-----------------------------------------------------------------------------
* <Rating>348</Rating>
*-----------------------------------------------------------------------------
    PROGRAM PACS.JL.BULKING.AUTO.Y
    $INSERT GLOBUS.BP I_COMMON
    $INSERT GLOBUS.BP I_EQUATE
    $INSERT GLOBUS.BP I_BATCH.FILES
    $INSERT GLOBUS.BP I_F.PGM.FILE
*-----------------------------------------------------------------
* 05 MAY 2016   C.Muruganand    Modified the routine PACS.JL.BULKING by adding
*                               Automated JOB.LIST backup and job.list validations steps
*-----------------------------------------------------------------
*-----------------------------
    HUSH ON
    CALL T24.INITIALISE
    HUSH OFF
*-----------------------------
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
* 05 MAY 2016 START
    FN.LIST.BK=LIST.NAME:".BAK"
    FV.LIST.BK=""
    CRT SYSTEM(1021)
    IF SYSTEM(1021)[1,4] = 'TAFJ' THEN
        EXECUTE "CREATE.FILE DATA ":FN.LIST.BK CAPTURING OUT1

    END ELSE
        EXECUTE "CREATE.FILE DATA ":FN.LIST.BK:" TYPE=UD" CAPTURING OUT1

    END
    CRT OUT1
    EXECUTE "CLEAR.FILE ":FN.LIST.BK
    OPEN FN.LIST.BK TO FV.LIST.BK ELSE
        CRT "CAN NOT OPEN FILE"
    END
    FN.TESTFILE="TEST.FILE"
    FV.TESTFILE=""
    EXECUTE "CREATE-FILE TEST.FILE TYPE=UD" CAPTURING OUT2
    CRT OUT2
    EXECUTE "CLEAR.FILE TEST.FILE"
    OPEN FN.TESTFILE TO FV.TESTFILE ELSE NULL
    EXECUTE "COPY FROM ":FN.LIST:" TO ":FN.LIST.BK:" ALL" CAPTURING OUT.EXE2

    GOSUB BACKUP.CHECK;
* 05 MAY 2016 END
    IF PROCEED.FURTHER THEN
        RUNNING.UNDER.BATCH=1

        BATCH.LIST.FILE ='TEST.FILE'
        SEL.CMD='SELECT ' : FN.LIST
        ID.LIST=''
        CALL EB.READLIST(SEL.CMD, FULL.LIST, '', NUMBER.OF.KEYS, '')

        LOOP
            REMOVE KEY1 FROM FULL.LIST SETTING YDELIM WHILE KEY1:YDELIM
            READ LIST.RECORD FROM FV.LIST, KEY1 THEN

                NO.OF.LIST.KEYS = DCOUNT(LIST.RECORD,FM)
                FOR LIDX = 1 TO NO.OF.LIST.KEYS   ;*Loop through one by one
                    Y.TEMP.LIST = ''
                    Y.TEMP.LIST = LIST.RECORD<LIDX>
                    CONVERT "" TO VM IN Y.TEMP.LIST
                    NO.OF.TEM.KEYS = DCOUNT(Y.TEMP.LIST,VM)

                    FOR J = 1 TO NO.OF.TEM.KEYS

                        IF ID.LIST THEN
                            ID.LIST<-1>= Y.TEMP.LIST<1,J>

                        END ELSE
                            ID.LIST= Y.TEMP.LIST<1,J>
                        END
                    NEXT J

                NEXT LIDX
            END ELSE
                NULL
            END
        REPEAT
        LIST.PARAMETER=''
        IF Y.BULK.NO THEN
            LIST.PARAMETER<6>=Y.BULK.NO
        END ELSE
            LIST.PARAMETER<6>=''
        END

        CALL BATCH.BUILD.LIST(LIST.PARAMETER,ID.LIST)
        RMSG = ''
        IF SYSTEM(47) THEN
            CALL EB.TRANS('END',RMSG)
        END
* 05 MAY 2016 START
        GOSUB FINAL.BACKUP;
        STOP
    END ELSE
        CRT "*******JOBLIST BACKUP NOT SUCCESSFUL, PLEASE RE-RUN THE ROUTINE*******"
    END
* 05 MAY 2016 END

    RETURN
* 05 MAY 2016 START
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
    CRT "COUNT.LIST.ORIG:":COUNT.LIST.ORIG
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
    CRT "COUNT.LIST.BK:":COUNT.LIST.BK
    RETURN

FINAL.BACKUP:
*===========*

    SEL.CMD.TEST.FILE='SELECT ':FN.TESTFILE
    ID.LIST.TEST.FILE=''
    CALL EB.READLIST(SEL.CMD.TEST.FILE, FULL.LIST.TEST.FILE, '', NUMBER.OF.KEYS.TEST.FILE, '')

    COUNT.LIST.TEST = ''
    CNT.TEST= ''
    LOOP
        REMOVE TEST.ID FROM FULL.LIST.TEST.FILE SETTING POS.TEST
    WHILE TEST.ID:POS.TEST

        READ TEST.REC FROM FV.TESTFILE,TEST.ID THEN
            CNT.TEST = DCOUNT(TEST.REC,@FM)

            IF CNT.TEST THEN
                COUNT.LIST.TEST = COUNT.LIST.TEST + CNT.TEST
            END ELSE
                COUNT.LIST.TEST = COUNT.LIST.TEST + 1
            END
        END
    REPEAT
    CRT "COUNT.LIST.TEST:":COUNT.LIST.TEST
   * IF COUNT.LIST.ORIG EQ COUNT.LIST.TEST THEN
        EXECUTE "CLEAR.FILE ":FN.LIST
        EXECUTE "COPY FROM ":FN.TESTFILE:" TO ":FN.LIST:" ALL" CAPTURING OUT3
        CRT OUT3
        GOSUB BACKUP.CHECK;
        IF PROCEED.FURTHER THEN
            CRT "BULKING COMPLETED"
        END ELSE
            CRT "***BULKING NOT SUCCESSFULL, PLEASE RE-RUN THE ROUTINE***"
            EXECUTE "CLEAR.FILE ":FN.LIST
            EXECUTE "COPY FROM ":FN.LIST.BK:" TO ":FN.LIST:" ALL"
        END
   * END ELSE
    *    CRT "***BULKING NOT SUCCESSFULL, PLEASE RE-RUN THE ROUTINE***"
    *END
    RETURN
* 05 MAY 2016 END
END 
