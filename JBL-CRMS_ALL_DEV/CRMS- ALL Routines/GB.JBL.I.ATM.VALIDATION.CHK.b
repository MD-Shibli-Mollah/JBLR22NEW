* @ValidationCode : MjoxMDUxNjU5OTMyOkNwMTI1MjoxNzA1MjI5NzExMzg0Om5hemloYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAxNzEwLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 14 Jan 2024 16:55:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazihar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0
*-----------------------------------------------------------------------------
*******Develop By: Robiul (JBL)********
*****Date: 31 JAN 2017 ***************
*-----------------------------------------------------------------------------
SUBROUTINE GB.JBL.I.ATM.VALIDATION.CHK
*-----------------------------------------------------------------------------
* Modification History :
* 1)
* Date :03/01/2024
* Modification Description : RETROFIT from TAFC to TAFJ
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------
* Subroutine Description: THIS ROUTINE IS USED FOR CRMS -
* Subroutine Type: INPUT
* Attached To    : EB.JBL.ATM.CARD.MGT,DELIVERY ; EB.JBL.ATM.CARD.MGT,RECEIVED ; EB.JBL.ATM.CARD.MGT,UPDATE
* Attached As    : INPUT ROUTINE
* TAFC Routine Name :ATM.VALIDATION.CHK - R09
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
* $INSERT GLOBUS.BP I_F.ACCOUNT
    $USING AC.AccountOpening
* $INSERT BP I_F.ATM.CARD.MGT
    $INSERT I_F.EB.JBL.ATM.CARD.MGT
* $INSERT GLOBUS.BP I_F.CARD.ISSUE
    $USING CQ.Cards
     
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "GB.JBL.I.ATM.VALIDATION.CHK Routine is found Successfully"
    FileName = 'SHIBLI_ATM.txt'
    FilePath = 'D:/Temenos/t24home/default/DL.BP'
    OPENSEQ FilePath,FileName TO FileOutput THEN NULL
    ELSE
        CREATE FileOutput ELSE
        END
    END
    WRITESEQ WriteData APPEND TO FileOutput ELSE
        CLOSESEQ FileOutput
    END
    CLOSESEQ FileOutput
*******--------------------------TRACER-END--------------------------------------------------------*********************

    FN.AC = "F.ACCOUNT"
    F.AC = ""
    FN.ATM = "F.EB.JBL.ATM.CARD.MGT"
    F.ATM = ""
    FN.ATM.NAU = "F.EB.JBL.ATM.CARD.MGT$NAU"
    F.ATM.NAU = ""
    FN.C.ISSUE = "F.CARD.ISSUE"
    F.C.ISSUE  = ""

    Y.PGM.VERSION = EB.SystemTables.getPgmVersion()
    Y.REQUEST = "EB.JBL.ATM.CARD.MGT":Y.PGM.VERSION
    Y.TODAY = EB.SystemTables.getToday()
    Y.VFUNCTION = EB.SystemTables.getVFunction()
    
* EB.DataAccess.Opf(YnameIn, YnameOut)
    EB.DataAccess.Opf(FN.ATM,F.ATM)
    EB.DataAccess.Opf(FN.ATM.NAU,F.ATM.NAU)
    EB.DataAccess.Opf(FN.C.ISSUE,F.C.ISSUE)

* Y.ACCOUNT=R.NEW(EB.ATM19.ACCT.NO)
    Y.ACCOUNT = EB.SystemTables.getRNew(EB.ATM19.ACCT.NO)
    
    EB.DataAccess.Opf(FN.AC,F.AC)
    EB.DataAccess.FRead(FN.AC,Y.ACCOUNT,R.AC.REC,F.AC,Y.ERR)
* Y.CATEGORY=R.AC.REC<AC.CATEGORY>
    Y.CATEGORY=R.AC.REC<AC.AccountOpening.Account.Category>

*-------------------------INIT ----- VER---------------------------------------------------

    Y.FROM.DATE = EB.SystemTables.getRNew(EB.ATM19.FROM.DATE)
    Y.TO.DATE = EB.SystemTables.getRNew(EB.ATM19.TO.DATE)
    Y.ATTR4 = EB.SystemTables.getRNew(EB.ATM19.ATTRIBUTE4)
    Y.CARD.STATUS = EB.SystemTables.getRNew(EB.ATM19.CARD.STATUS)
    Y.DELIVERY.DATE = EB.SystemTables.getRNew(EB.ATM19.DELIVERY.DATE)
    Y.ATM19.CARD.NO = EB.SystemTables.getRNew(EB.ATM19.CARD.NO)

*-------------------------INIT ----- VER---------END------------------------------------------

* IF R.NEW(EB.ATM19.FROM.DATE) > R.NEW(EB.ATM19.TO.DATE) THEN
    IF Y.FROM.DATE > Y.TO.DATE THEN
*        ETEXT ="FROM DATE MUST BE LESS THEN TO DATE"
        EB.SystemTables.setEtext("FROM DATE MUST BE LESS THEN TO DATE")
        EB.ErrorProcessing.StoreEndError()
    END

* IF R.NEW(EB.ATM19.ATTRIBUTE4) NE "" AND R.NEW(EB.ATM19.ATTRIBUTE4) > R.NEW(EB.ATM19.TO.DATE) THEN
    IF Y.ATTR4 NE "" AND Y.ATTR4 > Y.TO.DATE THEN
* ETEXT ="REISSUE DATE MUST BE LESS THEN TO DATE"
        EB.SystemTables.setEtext("REISSUE DATE MUST BE LESS THEN TO DATE")
        EB.ErrorProcessing.StoreEndError()
    END
    
* IF R.NEW(EB.ATM19.CARD.STATUS)="DONE" AND R.NEW(EB.ATM19.DELIVERY.DATE) NE "" AND R.NEW(EB.ATM19.DELIVERY.DATE) NE TODAY AND V$FUNCTION EQ 'I' THEN
    IF Y.CARD.STATUS EQ "DONE" AND Y.DELIVERY.DATE NE "" AND Y.DELIVERY.DATE NE Y.TODAY AND Y.VFUNCTION EQ 'I' THEN
* ETEXT ="DELIVERY DATE MUST BE TODAY"
        EB.SystemTables.setEtext("DELIVERY DATE MUST BE TODAY")
        EB.ErrorProcessing.StoreEndError()
    END

* IF LEN(R.NEW(EB.ATM19.CARD.NO)) NE 18 AND Y.REQUEST EQ "EB.ATM.CARD.MGT,UPDATE" THEN
    IF LEN(Y.ATM19.CARD.NO) NE 18 AND Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,UPDATE" THEN
* ETEXT ="CARD NUMBER MUST BE 18 DIGIT"
        EB.SystemTables.setEtext("CARD NUMBER MUST BE 18 DIGIT")
        EB.ErrorProcessing.StoreEndError()
    END
    
* ELSE  IF R.NEW(EB.ATM19.CARD.NO) NE "" AND R.NEW(EB.ATM19.CARD.STATUS)="APPROVED" AND Y.REQUEST EQ "EB.ATM.CARD.MGT,UPDATE" AND V$FUNCTION EQ 'I' THEN
    ELSE  IF Y.ATM19.CARD.NO NE "" AND Y.CARD.STATUS EQ "APPROVED" AND Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,UPDATE" AND Y.VFUNCTION EQ 'I' THEN
* Y.CARD.NO=R.NEW(EB.ATM19.CARD.NO)
        Y.CARD.NO = Y.ATM19.CARD.NO
        Y.CHECK = 0
        
        SEL.CMD = "SELECT ":FN.ATM:" WITH CARD.NO LIKE ..." : RIGHT(Y.CARD.NO,4)
* EB.DataAccess.Readlist(SelectStatement, KeyList, ListName, Selected, SystemReturnCode)
        EB.DataAccess.Readlist(SEL.CMD, SEL.LIST, "", NO.OF.RECORD, RET.CODE)
        LOOP
            REMOVE Y.REC.ID FROM SEL.LIST SETTING Y.POS
        WHILE Y.REC.ID:Y.POS

            EB.DataAccess.FRead(FN.ATM, Y.REC.ID, R.ATM.REC, F.ATM, Y.ERR)
            Y.CARD.NODB = R.ATM.REC<EB.ATM19.CARD.NO>
            Y.MASK = R.ATM.REC<EB.ATM19.CARD.MASK>
* Y.CARD.NAME = R.NEW(EB.ATM19.CARD.NAME)
            Y.CARD.NAME = EB.SystemTables.getRNew(EB.ATM19.CARD.NAME)
            
            CALL ATM.MS.MASK(Y.MASK,"DEP",Y.RESULT.DATA,Y.CARD.NAME)
            
            Y.CARD.NO = LEFT(Y.CARD.NODB,6):Y.RESULT.DATA:RIGHT(Y.CARD.NODB,4)
* IF Y.CARD.NO EQ R.NEW(EB.ATM19.CARD.NO) THEN
            IF Y.CARD.NO EQ Y.ATM19.CARD.NO THEN
* ETEXT ="CARD NUMBER ALREADY USED ANOTHER ACCOUNT"
                EB.SystemTables.setEtext("CARD NUMBER IS ALREADY USED BY ANOTHER ACCOUNT")
                EB.ErrorProcessing.StoreEndError()
                Y.CHECK = 1
                BREAK
            END
        REPEAT

        IF Y.CHECK EQ 0 THEN
            SEL.CMD = "SELECT ":FN.ATM.NAU:" WITH CARD.NO LIKE ..." : RIGHT(Y.CARD.NO,4)
* CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.RECORD,RET.CODE)
            EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,"",NO.OF.RECORD,RET.CODE)
            LOOP
                REMOVE Y.REC.ID FROM SEL.LIST SETTING Y.POS
            WHILE Y.REC.ID:Y.POS
                EB.DataAccess.FRead(FN.ATM.NAU,Y.REC.ID,R.ATM.REC,F.ATM.NAU,Y.ERR)
                Y.CARD.NODB = R.ATM.REC<EB.ATM19.CARD.NO>
                Y.MASK = R.ATM.REC<EB.ATM19.CARD.MASK>
* Y.CARD.NAME = R.NEW(EB.ATM19.CARD.NAME)
                Y.CARD.NAME = EB.SystemTables.getRNew(EB.ATM19.CARD.NAME)
            
                CALL ATM.MS.MASK(Y.MASK,"DEP",Y.RESULT.DATA,Y.CARD.NAME)
                
                Y.CARD.NO=LEFT(Y.CARD.NODB,6):Y.RESULT.DATA:RIGHT(Y.CARD.NODB,4)
                
* IF Y.CARD.NO EQ R.NEW(EB.ATM19.CARD.NO) THEN
                IF Y.CARD.NO EQ Y.CARD.NODB THEN
* ETEXT ="CARD NUMBER ALREADY USED ANOTHER ACCOUNT"
                    EB.SystemTables.setEtext("CARD NUMBER IS ALREADY USED BY ANOTHER ACCOUNT")
                    EB.ErrorProcessing.StoreEndError()
                    BREAK
                END
            REPEAT
        END
    END
    
    SEL.CMD = "SELECT ":FN.C.ISSUE:" WITH @ID LIKE ..." : Y.ATM19.CARD.NO
    EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,"",NO.OF.RECORD,RET.CODE)

    IF NO.OF.RECORD > 0 THEN
* ETEXT ="CARD NUMBER ALREADY USED ANOTHER ACCOUNT"
        EB.SystemTables.setEtext("CARD NUMBER IS ALREADY USED BY ANOTHER ACCOUNT")
        EB.ErrorProcessing.StoreEndError()
    END
RETURN
END

