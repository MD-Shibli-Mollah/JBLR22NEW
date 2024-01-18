* @ValidationCode : MjotMzI1MjkyMTU3OkNwMTI1MjoxNzA0Nzc2NTA2NDE0Om5hemloYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAxNzEwLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Jan 2024 11:01:46
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
SUBROUTINE GB.JBL.BA.ATM.ACC.MARKER
*-----------------------------------------------------------------------------
* Modification History :
* 1)
* Date :31/12/2023
* Modification Description :  RETROFIT from TAFC to TAFJ
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
* Subroutine Description: THIS ROUTINE IS USED FOR CRMS
* Subroutine Type: BEFORE AUTH
* Attached To    : EB.JBL.ATM.CARD.MGT
* Attached As    : BEFORE AUTH ROUTINE
* TAFC Routine Name :ATM.ACC.CHK - R09
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*    $INSERT GLOBUS.BP I_F.ACCOUNT
    $USING AC.AccountOpening
*    $INSERT BP I_F.ATM.CARD.MGT
    $INSERT I_F.EB.JBL.ATM.CARD.MGT
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Foundation
    $USING EB.ErrorProcessing
    $USING EB.TransactionControl
    $USING EB.API
    $USING EB.LocalReferences
    
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "GB.JBL.BA.ATM.ACC.MARKER Routine is found Successfully"
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
    FN.AC.NAU = "F.ACCOUNT$NAU"
    F.AC.NAU = ""
    FN.ATM = "F.EB.JBL.ATM.CARD.MGT"
    F.ATM = ""
    
* Y.ACCOUNT=R.NEW(EB.ATM19.ACCT.NO)
    Y.ACCOUNT = EB.SystemTables.getRNew(EB.ATM19.ACCT.NO)
    Y.ID.NEW = EB.SystemTables.getIdNew()
    Y.PGM.VERSION = EB.SystemTables.getPgmVersion()
       
    EB.DataAccess.Opf(FN.AC, F.AC)
    EB.DataAccess.Opf(FN.AC.NAU, F.AC.NAU)
    EB.DataAccess.Opf(FN.ATM, F.ATM)

    EB.DataAccess.FRead(FN.AC, Y.ACCOUNT, R.AC.REC, F.AC,Y.ERR)
    EB.DataAccess.FRead(FN.AC.NAU, Y.ACCOUNT, R.AC.NAU, F.AC.NAU, Y.ERR)
    EB.DataAccess.FRead(FN.ATM, Y.ID.NEW, R.ATM.REC, F.ATM, Y.ERR)

* Y.POSTING.RESTRICT=R.AC.REC<AC.POSTING.RESTRICT>
    Y.POSTING.RESTRICT = R.AC.REC<AC.AccountOpening.Account.PostingRestrict>

* CALL GET.LOC.REF('ACCOUNT','AC.ATM.CARD.NUM',Y.AC.ATM.CARD.NUM)
    
    APPLICATION.NAME = 'ACCOUNT'
    Y.FILED.NAME = 'LT.AC.ATM.CARD.NUM'
    Y.FIELD.POS = ''
    EB.LocalReferences.GetLocRef(APPLICATION.NAME,Y.FILED.NAME,Y.FIELD.POS)
    Y.LT.AC.ATM.CARD.NUM = R.AC.REC<AC.AccountOpening.Account.LocalRef, Y.FIELD.POS>
    
    Y.REQUEST = "EB.JBL.ATM.CARD.MGT":Y.PGM.VERSION
    
*-------------------------INIT----VER----------------------------------------------------*
    Y.CARD.STATUS = EB.SystemTables.getRNew(EB.ATM19.CARD.STATUS)
    Y.CARD.MASK = EB.SystemTables.getRNew(EB.ATM19.CARD.MASK)
    Y.REQUEST.TYPE = EB.SystemTables.getRNew(EB.ATM19.REQUEST.TYPE)
    Y.TODAY = EB.SystemTables.getToday()
    
*IF R.NEW(EB.ATM19.CARD.STATUS) EQ "APPROVED" AND Y.REQUEST EQ "EB.ATM.CARD.MGT,UPDATE" THEN
    IF Y.CARD.STATUS EQ "APPROVED" AND Y.REQUEST EQ "EB.ATM.CARD.MGT,UPDATE" THEN
* Y.CARD.NO = R.NEW(EB.ATM19.CARD.NO)
        Y.CARD.NO = EB.SystemTables.getRNew(EB.ATM19.CARD.NO)
        Y.LEN = LEN(Y.CARD.NO)
        Y.CARD.MID = SUBSTRINGS(Y.CARD.NO,7,8)
* Y.CARD.NAME=R.NEW(EB.ATM19.CARD.NAME)
        Y.CARD.NAME = EB.SystemTables.getRNew(EB.ATM19.CARD.NAME)
        
        CALL ATM.MS.MASK(Y.CARD.MID,"ENP",Y.RESULT.DATA,Y.CARD.NAME)
        Y.CARD.NO=LEFT(Y.CARD.NO,6):"********":SUBSTRINGS(Y.CARD.NO,15,Y.LEN)
        
* R.NEW(EB.ATM19.CARD.MASK) =Y.RESULT.DATA
        EB.SystemTables.setRNew(EB.ATM19.CARD.MASK, Y.RESULT.DATA)
* IF R.NEW(EB.ATM19.CARD.MASK) EQ "" THEN
        IF Y.CARD.MASK EQ "" THEN
*            ETEXT ="MASK ERROR"
            EB.SystemTables.setEtext("MASK ERROR")
*            CALL STORE.END.ERROR
            EB.ErrorProcessing.StoreEndError()
        END
    
*        R.NEW(EB.ATM19.CARD.NO)=Y.CARD.NO
        EB.SystemTables.setRNew(EB.ATM19.CARD.NO, Y.CARD.NO)
*        R.NEW(EB.ATM19.CARD.CLOSE.DATE)=""
        EB.SystemTables.setRNew(EB.ATM19.CARD.CLOSE.DATE, "")
    END

    IF R.AC.REC EQ "" THEN
*        ETEXT = "ACCOUNT MISSING"
        EB.SystemTables.setEtext("ACCOUNT MISSING")
*        CALL STORE.END.ERROR
        EB.ErrorProcessing.StoreEndError()
    END

    ELSE IF Y.POSTING.RESTRICT NE "" AND R.AC.REC NE "" THEN
*        ETEXT = Y.ACCOUNT: " IS POSTING RESTRICTED"
        EB.SystemTables.setEtext( Y.ACCOUNT: " IS POSTING RESTRICTED")
*        CALL STORE.END.ERROR
        EB.ErrorProcessing.StoreEndError()
    END

* ELSE IF R.NEW(EB.ATM19.CARD.STATUS) EQ "PENDING" AND  R.AC.NAU EQ "" AND ( R.NEW(EB.ATM19.REQUEST.TYPE) EQ "ISSUE" OR R.NEW(EB.ATM19.REQUEST.TYPE) EQ "REISSUE" )  THEN
    ELSE IF (Y.CARD.STATUS EQ "PENDING" AND  R.AC.NAU EQ "" AND Y.REQUEST.TYPE EQ "ISSUE" OR Y.REQUEST.TYPE EQ "REISSUE" ) THEN
        ACC = DCOUNT(Y.LT.AC.ATM.CARD.NUM, @SM)
        Y.FLAG.ACC=0
        
        FOR I = 1 TO ACC
* IF R.AC.REC<AC.LOCAL.REF,Y.AC.ATM.CARD.NUM,I> EQ ID.NEW THEN
            IF R.AC.REC<AC.AccountOpening.Account.LocalRef,Y.FIELD.POS,I> EQ Y.ID.NEW THEN
                Y.FLAG.ACC=1
                BREAK
            END
        NEXT I
    
        IF Y.FLAG.ACC EQ 0 THEN
            ACC=ACC+1
* R.AC.REC<AC.LOCAL.REF,Y.AC.ATM.CARD.NUM,ACC>= ID.NEW
            R.AC.REC<AC.AccountOpening.Account.LocalRef,Y.FIELD.POS,ACC>= Y.ID.NEW
* CALL F.WRITE(FN.AC,Y.ACCOUNT,R.AC.REC)
            EB.DataAccess.FWrite(FN.AC,Y.ACCOUNT,R.AC.REC)
            EB.TransactionControl.JournalUpdate(Y.ACCOUNT)
        
        END
    END

* ELSE IF R.NEW(EB.ATM19.CARD.STATUS) EQ "DONE" AND  R.AC.NAU EQ "" THEN
    ELSE IF Y.CARD.STATUS EQ "DONE" AND  R.AC.NAU EQ "" THEN

*        R.NEW(EB.ATM19.ATTRIBUTE1)=""
        EB.SystemTables.setRNew(EB.ATM19.ATTRIBUTE1, "")
*        R.NEW(EB.ATM19.ATTRIBUTE5)=""
        EB.SystemTables.setRNew(EB.ATM19.ATTRIBUTE5, "")

* ACC = DCOUNT(R.AC.REC<AC.LOCAL.REF,Y.AC.ATM.CARD.NUM>,@SM)
        ACC = DCOUNT(Y.LT.AC.ATM.CARD.NUM, @SM)
        
* IF R.NEW(EB.ATM19.CARD.STATUS) EQ "DONE" AND ( R.NEW(EB.ATM19.REQUEST.TYPE) EQ "ISSUE" OR R.NEW(EB.ATM19.REQUEST.TYPE) EQ "REISSUE" ) THEN
        IF Y.CARD.STATUS EQ "DONE" AND ( Y.REQUEST.TYPE EQ "ISSUE" OR Y.REQUEST.TYPE EQ "REISSUE" ) THEN
            Y.FLAG.ACC=0
            FOR I = 1 TO ACC
                IF R.AC.REC<AC.AccountOpening.Account.LocalRef, Y.FIELD.POS, I> EQ Y.ID.NEW THEN
                    Y.FLAG.ACC=1
                    BREAK
                END
            NEXT I
        
            IF Y.FLAG.ACC EQ 0 THEN
                ACC=ACC+1
                R.AC.REC<AC.AccountOpening.Account.LocalRef, Y.FIELD.POS, ACC>= Y.ID.NEW
            END
* R.NEW(EB.ATM19.CARD.CLOSE.DATE)=""
            EB.SystemTables.setRNew(EB.ATM19.CARD.CLOSE.DATE, "")
        END

* IF R.NEW(EB.ATM19.REQUEST.TYPE) EQ "CLOSE" THEN
        IF Y.REQUEST.TYPE EQ "CLOSE" THEN
            FOR I = 1 TO ACC
                IF R.AC.REC<AC.AccountOpening.Account.LocalRef, Y.FIELD.POS, I> EQ Y.ID.NEW THEN
* DEL R.AC.REC<AC.LOCAL.REF,Y.AC.ATM.CARD.NUM,I>
                    DEL R.AC.REC<AC.AccountOpening.Account.LocalRef,Y.FIELD.POS,I>
                    BREAK
                END
            NEXT I
* R.NEW(EB.ATM19.CARD.CLOSE.DATE)=TODAY
            EB.SystemTables.setRNew(EB.ATM19.CARD.CLOSE.DATE, Y.TODAY)
        END

* CALL F.WRITE(FN.AC,Y.ACCOUNT,R.AC.REC)
        EB.DataAccess.FWrite(FN.AC,Y.ACCOUNT,R.AC.REC)
        EB.TransactionControl.JournalUpdate(Y.ACCOUNT)
    END

    ELSE IF ( Y.CARD.STATUS EQ "DONE" OR Y.CARD.STATUS EQ "PENDING" ) AND  R.AC.NAU NE "" THEN
*        ETEXT ="ACCOUNT AUTHORISE PENDING"
        EB.SystemTables.setEtext("ACCOUNT AUTHORISE PENDING")
*        CALL STORE.END.ERROR
        EB.ErrorProcessing.StoreEndError()
    END
    !CALL JOURNAL.UPDATE('')
RETURN
END

