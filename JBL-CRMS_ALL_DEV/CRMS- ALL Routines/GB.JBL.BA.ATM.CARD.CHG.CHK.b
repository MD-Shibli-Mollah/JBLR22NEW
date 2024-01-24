* @ValidationCode : MjoxMjQ2Njk1NTQ2OkNwMTI1MjoxNzA0Nzc2MDc3NTMwOm5hemloYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAxNzEwLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Jan 2024 10:54:37
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
* <Rating>795</Rating>
*-----------------------------------------------------------------------------
* Developed By: Robiul Islam
* Deployed Date: 19 FEB 2017
*-----------------------------------------------------------------------------
SUBROUTINE GB.JBL.BA.ATM.CARD.CHG.CHK
    !PROGRAM ATM.CARD.CHG.CHK
*-----------------------------------------------------------------------------
* Modification History :
* 1)
* Date :03/01/2024
* Modification Description : RETROFIT from TAFC to TAFJ
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
* Subroutine Description: THIS ROUTINE IS USED FOR CRMS -
* Subroutine Type: BA
* Attached To    : EB.JBL.ATM.CARD.MGT,DELIVERY ; EB.JBL.ATM.CARD.MGT,CLOSEBR
* Attached As    : BEFORE AUTH ROUTINE
* TAFC Routine Name :ATM.VALIDATION.CHK - R09
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
* $INSERT GLOBUS.BP I_F.ACCOUNT
    $USING AC.AccountOpening
*    $INSERT BP I_F.ATM.CARD.MGT
    $INSERT I_F.EB.JBL.ATM.CARD.MGT
*    $INSERT GLOBUS.BP I_F.CARD.CHARGE
*    $INSERT GLOBUS.BP I_F.CARD.ISSUE
*    $INSERT GLOBUS.BP I_F.CARD.TYPE
    $USING CQ.Cards
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.TransactionControl
    $USING EB.Interface
    
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "GB.JBL.BA.ATM.CARD.CHG.CHK Routine is found Successfully"
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
    FN.CARD.CHG = "F.CARD.CHARGE"
    F.CARD.CHG = ""

    FN.CARD.TYPE = "F.CARD.TYPE"
    F.CARD.TYPE = ""

    FN.CARD.ISSUE = "F.CARD.ISSUE"
    F.CARD.ISSUE = ""
    FN.CARD.ISSUE.ACCOUNT = "F.CARD.ISSUE.ACCOUNT"
    F.CARD.ISSUE.ACCOUNT = ""
    FN.ATM = "F.EB.ATM.CARD.MGT"
    F.ATM = ""
    FN.ATM.NAU = "F.EB.ATM.CARD.MGT$NAU"
    F.ATM.NAU = ""
    
    Y.PGM.VERSION = EB.SystemTables.getPgmVersion()
    Y.REQUEST="EB.ATM.CARD.MGT":Y.PGM.VERSION
    
*EB.DataAccess.Opf(YnameIn, YnameOut)
    EB.DataAccess.Opf(FN.ATM,F.ATM)
    EB.DataAccess.Opf(FN.ATM.NAU,F.ATM.NAU)
    EB.DataAccess.Opf(FN.CARD.CHG,F.CARD.CHG)
    EB.DataAccess.Opf(FN.CARD.ISSUE,F.CARD.ISSUE)
    EB.DataAccess.Opf(FN.CARD.ISSUE.ACCOUNT,F.CARD.ISSUE.ACCOUNT)
    EB.DataAccess.Opf(FN.CARD.TYPE,F.CARD.TYPE)

* Y.ACCOUNT=R.NEW(EB.ATM19.ACCT.NO)
    Y.ACCOUNT = EB.SystemTables.getRNew(EB.ATM19.ACCT.NO)
    
    EB.DataAccess.Opf(FN.AC,F.AC)
    
    EB.DataAccess.FRead(FN.AC, Y.ACCOUNT, R.AC.REC, F.AC, Y.ERR)
* Y.CATEGORY=R.AC.REC<AC.CATEGORY>
    Y.CATEGORY = R.AC.REC<AC.AccountOpening.Account.Category>
* Y.CHG.ID=R.NEW(EB.ATM19.ACCT.CATEGORY)
    Y.CHG.ID = EB.SystemTables.getRNew(EB.ATM19.ACCT.CATEGORY)

*---------------Assigning to new Var------------------------------------------------*
    Y.CARD.STATUS = EB.SystemTables.getRNew(EB.ATM19.CARD.STATUS)
    Y.ATM.REQ.TYPE = EB.SystemTables.getRNew(EB.ATM19.REQUEST.TYPE)
    Y.ATM.ISS.TIME = EB.SystemTables.getRNew(EB.ATM19.ISSUE.TIME)
    Y.CARD.CLOSE.DATE = EB.SystemTables.getRNew(EB.ATM19.CARD.CLOSE.DATE)
    Y.ATM.ATTRIBUTE4 = EB.SystemTables.getRNew(EB.ATM19.ATTRIBUTE4)
    Y.DELIVERY.DATE = EB.SystemTables.getRNew(EB.ATM19.DELIVERY.DATE)
    Y.FROM.DATE = EB.SystemTables.getRNew(EB.ATM19.FROM.DATE)
    Y.TO.DATE = EB.SystemTables.getRNew(EB.ATM19.TO.DATE)
    
    Y.VFUNCTION = EB.SystemTables.getVFunction()
    Y.TODAY = EB.SystemTables.getToday()
    Y.IDCOMPANY = EB.SystemTables.getIdCompany()
*---------------Assigning to new Var---------------END---------------------------------*

    IF Y.CATEGORY EQ 1001 THEN
        Y.TYPE.ID=1
    END
    ELSE IF Y.CATEGORY EQ 6001 THEN
        Y.TYPE.ID=2
    END
    ELSE IF Y.CATEGORY EQ 6004 THEN
        Y.TYPE.ID=3
    END
    ELSE IF Y.CATEGORY EQ 6019 THEN
        Y.TYPE.ID=4
    END


    EB.DataAccess.FRead(FN.CARD.CHG, Y.TYPE.ID, R.CARD.CHG, F.CARD.CHG, Y.ERR)
* Y.ISSUE.CHR=R.CARD.CHG<CARD.CHG.ISSUE.CHARGE>
    Y.ISSUE.CHR = R.CARD.CHG<CQ.Cards.CardCharge.CardChgIssueCharge>

* IF R.NEW(EB.ATM19.REQUEST.TYPE) EQ "REISSUE" OR R.NEW(EB.ATM19.REQUEST.TYPE) EQ "CLOSE" THEN
    IF Y.ATM.REQ.TYPE EQ "REISSUE" OR Y.ATM.REQ.TYPE EQ "CLOSE" THEN
        EB.DataAccess.FRead(FN.CARD.ISSUE.ACCOUNT, Y.ACCOUNT, R.ISSUE.ACCOUNT, F.CARD.ISSUE.ACCOUNT, Y.ERR)
        Y.REASON.COUNT=DCOUNT(R.ISSUE.ACCOUNT,@FM)
        
        FOR I = 1 TO Y.REASON.COUNT
            Y.ISSUE.ID = FIELD(R.ISSUE.ACCOUNT,@FM,I)
            EB.DataAccess.FRead(FN.CARD.ISSUE, Y.ISSUE.ID, R.ISSUE.REC, F.CARD.ISSUE, Y.ERR)
            Y.CANCELLATION.DATE = R.ISSUE.REC<CQ.Cards.CardIssue.CardIsCancellationDate>
            Y.IS.EXPIRY.DATE = R.ISSUE.REC<CQ.Cards.CardIssue.CardIsExpiryDate>
            Y.PIN.ISSUE.DATE = R.ISSUE.REC<CQ.Cards.CardIssue.CardIsPinIssueDate>
            
* IF R.ISSUE.REC<CARD.IS.CANCELLATION.DATE> EQ "" THEN
            IF Y.CANCELLATION.DATE EQ "" THEN
* IF R.NEW(EB.ATM19.REQUEST.TYPE) EQ "REISSUE" THEN
                IF Y.ATM.REQ.TYPE EQ "REISSUE" THEN
* R.ISSUE.REC<CARD.IS.CAN.REASON> =6
                    R.ISSUE.REC<CQ.Cards.CardIssue.CardIsCanReason> = 6
* IF R.NEW(EB.ATM19.DELIVERY.DATE) GE R.ISSUE.REC<CARD.IS.EXPIRY.DATE> THEN
                    IF Y.DELIVERY.DATE GE Y.IS.EXPIRY.DATE THEN
* R.ISSUE.REC<CARD.IS.CANCELLATION.DATE>=R.ISSUE.REC<CARD.IS.EXPIRY.DATE>
                        Y.CANCELLATION.DATE = Y.IS.EXPIRY.DATE
                    END
                
                    ELSE
* R.ISSUE.REC<CARD.IS.CANCELLATION.DATE>=R.NEW(EB.ATM19.DELIVERY.DATE)
                        Y.IS.CANCELLATION.DATE= Y.DELIVERY.DATE
                    END
                END
                ELSE
* R.ISSUE.REC<CARD.IS.CAN.REASON> =7
                    R.ISSUE.REC<CQ.Cards.CardIssue.CardIsCanReason> = 7
* IF R.NEW(EB.ATM19.CARD.CLOSE.DATE) GE R.ISSUE.REC<CARD.IS.EXPIRY.DATE> THEN
                    IF Y.CARD.CLOSE.DATE GE Y.IS.EXPIRY.DATE THEN
* R.ISSUE.REC<CARD.IS.CANCELLATION.DATE>=R.ISSUE.REC<CARD.IS.EXPIRY.DATE>
                        Y.CANCELLATION.DATE = Y.IS.EXPIRY.DATE
                    END
                    
                    ELSE
* R.ISSUE.REC<CARD.IS.CANCELLATION.DATE>=R.NEW(EB.ATM19.CARD.CLOSE.DATE)
                        Y.CANCELLATION.DATE = Y.CARD.CLOSE.DATE
                    END
                END
            
* CALL F.WRITE(FN.CARD.ISSUE,Y.ISSUE.ID,R.ISSUE.REC)
                EB.DataAccess.FWrite(FN.CARD.ISSUE, Y.ISSUE.ID, R.ISSUE.REC)
                EB.TransactionControl.JournalUpdate(Y.ISSUE.ID)
                BREAK
            END
        NEXT I
    END

    Y.CARD.NODB = EB.SystemTables.getRNew(EB.ATM19.CARD.NO)
    Y.MASK = EB.SystemTables.getRNew(EB.ATM19.CARD.MASK)
    Y.CARD.NAME = EB.SystemTables.getRNew(EB.ATM19.CARD.NAME)
    
    CALL ATM.MS.MASK(Y.MASK,"DEP",Y.RESULT.DATA,Y.CARD.NAME)
    
    Y.CARD.NO = LEFT(Y.CARD.NODB,6):Y.RESULT.DATA:RIGHT(Y.CARD.NODB,4)
    Y.ID = Y.TYPE.ID:".":Y.CARD.NO
    Y.AC.ID = Y.ACCOUNT
    Y.NAME = EB.SystemTables.getRNew(EB.ATM19.CARD.NAME)

* IF R.NEW(EB.ATM19.ATTRIBUTE4) NE ""  AND R.NEW(EB.ATM19.FROM.DATE)< R.NEW(EB.ATM19.ATTRIBUTE4) THEN
    IF Y.ATM.ATTRIBUTE4 NE ""  AND Y.FROM.DATE < Y.ATM.ATTRIBUTE4 THEN
* Y.ISSUE.DATE=R.NEW(EB.ATM19.ATTRIBUTE4)
        Y.ISSUE.DATE = EB.SystemTables.getRNew(EB.ATM19.ATTRIBUTE4)
    END
    
    ELSE
* Y.ISSUE.DATE=R.NEW(EB.ATM19.FROM.DATE)
        Y.ISSUE.DATE = EB.SystemTables.getRNew(EB.ATM19.FROM.DATE)
    END

    !Y.ISSUE.DATE=R.NEW(EB.ATM19.FROM.DATE)
    Y.EXPIRY.DATE = EB.SystemTables.getRNew(EB.ATM19.TO.DATE)
    Y.SOURCE = "DM.OFS.SRC"
* RUNNING.UNDER.BATCH = 1  --- LOCAL VAR --- NOT REQ ---------
* IF R.NEW(EB.ATM19.REQUEST.TYPE) EQ "PINREISSUE" THEN
    IF Y.ATM.REQ.TYPE EQ "PINREISSUE" THEN
        EB.DataAccess.FRead(FN.CARD.ISSUE, Y.ID, R.ISSUE.REC, F.CARD.ISSUE, Y.ERR)
* IF R.NEW(EB.ATM19.DELIVERY.DATE) GE R.ISSUE.REC<CARD.IS.EXPIRY.DATE> THEN
        IF Y.DELIVERY.DATE GE Y.IS.EXPIRY.DATE THEN
* R.ISSUE.REC<CARD.IS.PIN.ISSUE.DATE>=R.ISSUE.REC<CARD.IS.EXPIRY.DATE>
            Y.PIN.ISSUE.DATE = Y.IS.EXPIRY.DATE
        END
    
        ELSE
* R.ISSUE.REC<CARD.IS.PIN.ISSUE.DATE>=R.NEW(EB.ATM19.DELIVERY.DATE)
            Y.PIN.ISSUE.DATE = Y.DELIVERY.DATE
        END
* CALL F.WRITE(FN.CARD.ISSUE,Y.ID,R.ISSUE.REC)
        EB.DataAccess.FWrite(FN.CARD.ISSUE, Y.ID, R.ISSUE.REC)
    END

    !DEBUG
* IF R.NEW(EB.ATM19.REQUEST.TYPE) EQ "ISSUE" OR R.NEW(EB.ATM19.REQUEST.TYPE) EQ "REISSUE"  THEN
    IF Y.ATM.REQ.TYPE EQ "ISSUE" OR Y.ATM.REQ.TYPE EQ "REISSUE" THEN
        Y.ISSUE.CHR = 0
        Y.MESSAGE = "CARD.ISSUE,INPUT/I/PROCESS,DMUSER.1//":Y.IDCOMPANY:",":Y.ID:",ACCOUNT=":Y.AC.ID:",NAME=":Y.NAME:",ISSUE.DATE=":Y.ISSUE.DATE:",EXPIRY.DATE=":Y.EXPIRY.DATE:",CHARGES=":Y.ISSUE.CHR
       
* CALL OFS.GLOBUS.MANAGER(Y.SOURCE,Y.MESSAGE)
        EB.Interface.OfsGlobusManager(Y.SOURCE, Y.MESSAGE)

* Y.RUNNING.UNDER.BATCH = 0  --- LOCAL VAR --- NOT REQ ---------
* SENSITIVITY=''
    END
RETURN
END

