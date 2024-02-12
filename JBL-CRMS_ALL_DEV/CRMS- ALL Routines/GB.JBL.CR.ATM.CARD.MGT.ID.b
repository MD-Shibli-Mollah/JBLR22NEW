* @ValidationCode : MjotOTUyODkzODY6Q3AxMjUyOjE3MDQ3NzY4NjI3Mjc6bmF6aWhhcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDE3MTAuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Jan 2024 11:07:42
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
SUBROUTINE GB.JBL.CR.ATM.CARD.MGT.ID
*-----------------------------------------------------------------------------
* Modification History :
* 1)
* Date :31/12/2023
* Modification Description :  RETROFIT from TAFC to TAFJ
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------
* Subroutine Description: THIS ROUTINE IS USED FOR CRMS
* Subroutine Type: CHECK RECORD
* Attached To    : EB.JBL.ATM.CARD.MGT,CLOSE
* Attached As    : CHECK RECORD ROUTINE
* TAFC Routine Name : ATM.CARD.MGT.ID - R09
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
* $INSERT GLOBUS.BP I_F.ACCOUNT
    $USING AC.AccountOpening
    $INSERT I_F.EB.JBL.ATM.CARD.MGT
    $INSERT I_F.EB.JBL.CARD.BATCH.INFO
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.DataAccess
    $USING EB.LocalReferences

*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "GB.JBL.CR.ATM.CARD.MGT.ID Routine is found Successfully"
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

    FN.CARD = "F.EB.JBL.CARD.BATCH.INFO"
    F.CARD = ''

*-----------------------INIT --------- VAR----------------------------------------*
    Y.ACC = EB.SystemTables.getRNew(EB.ATM19.ACCT.NO)
    Y.PGM.VERSION = EB.SystemTables.getPgmVersion()
    Y.VFUNCTION = EB.SystemTables.getVFunction()
    Y.REQUEST.TYPE = EB.SystemTables.getRNew(EB.ATM19.REQUEST.TYPE)
    Y.CARD.CLOSE.DATE = EB.SystemTables.getRNew(EB.ATM19.CARD.CLOSE.DATE)

    EB.DataAccess.Opf(FN.CARD, F.CARD)

    EB.DataAccess.FRead(FN.CARD, Y.ACC, R.CARD, F.CARD, ERR)
    Y.INFO.STATUS = R.CARD<EB.JBCARD.INFO.STATUS>
    Y.INFO.BIN = R.CARD<EB.JBCARD.INFO.BIN>
    Y.INFO.CARD.NO = R.CARD<EB.JBCARD.INFO.CARD.NO>
    Y.INFO.EXPIRE.DATE = R.CARD<EB.JBCARD.INFO.EXPIRE.DATE>
    Y.INFO.ISSUE.DATE = R.CARD<EB.JBCARD.INFO.ISSUE.DATE>
    
    
    Y.REQUEST = "EB.JBL.ATM.CARD.MGT":Y.PGM.VERSION

    IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,DELIVERY" AND Y.VFUNCTION EQ 'I'  THEN
* R.NEW(EB.ATM19.DELIVERY.DATE)=""
        EB.SystemTables.setRNew(EB.ATM19.DELIVERY.DATE, "")
    END
* R.NEW(EB.ATM19.NARRATIVE)=""
    EB.SystemTables.setRNew(EB.ATM19.NARRATIVE, "")
   
    IF (Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,REISSUE"  OR Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,CLOSE" OR Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,PINREQ") AND Y.VFUNCTION EQ 'I' THEN
*        R.NEW(EB.ATM19.ISSUE.WAIVE.CHARGE)="NO"
        EB.SystemTables.setRNew(EB.ATM19.ISSUE.WAIVE.CHARGE, "NO")
*        R.NEW(EB.ATM19.REISSUE.REASON)=""
        EB.SystemTables.setRNew(EB.ATM19.REISSUE.REASON, "")
    END
    IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,UPDATE" AND Y.VFUNCTION EQ 'I' AND Y.REQUEST.TYPE NE "REISSUE" THEN
        T(EB.ATM19.ATTRIBUTE4)<3> = 'NOINPUT'
    END

    IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,UPDATE" AND Y.VFUNCTION EQ 'I' AND Y.REQUEST.TYPE EQ "REISSUE" THEN
* IF R.NEW(EB.ATM19.CARD.CLOSE.DATE) NE "" THEN
        IF Y.CARD.CLOSE.DATE NE "" THEN
* R.NEW(EB.ATM19.FROM.DATE)= ""
            EB.SystemTables.setRNew(EB.ATM19.FROM.DATE, "")
* T(EB.ATM19.ATTRIBUTE4)<3> = 'NOINPUT'
            EB.SystemTables.setT(EB.ATM19.ATTRIBUTE4, 'NOINPUT')
        END
* ELSE IF R.NEW(EB.ATM19.CARD.CLOSE.DATE) EQ "" THEN
        ELSE IF Y.CARD.CLOSE.DATE EQ "" THEN
*            T(EB.ATM19.FROM.DATE)<3> = 'NOINPUT'
            EB.SystemTables.setT(EB.ATM19.FROM.DATE, 'NOINPUT')
*            R.NEW(EB.ATM19.ATTRIBUTE4) =""
            EB.SystemTables.setRNew(EB.ATM19.ATTRIBUTE4, "")
        END
    END

    IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,UPDATE" AND Y.VFUNCTION EQ 'I' THEN
* R.NEW(EB.ATM19.CARD.NO)=""
        EB.SystemTables.setRNew(EB.ATM19.CARD.NO, "")

*        R.NEW(EB.ATM19.TO.DATE)=""
        EB.SystemTables.setRNew(EB.ATM19.TO.DATE, "")
*        R.NEW(EB.ATM19.BIN.CARD.NUM)=""
        EB.SystemTables.setRNew(EB.ATM19.BIN.CARD.NUM, "")

* IF R.CARD NE '' AND R.CARD<JBCARD.INFO.STATUS> EQ "PENDING" THEN
        IF R.CARD NE '' AND Y.INFO.STATUS EQ "PENDING" THEN
*            R.NEW(EB.ATM19.BIN.CARD.NUM) = R.CARD<JBCARD.INFO.BIN>
            EB.SystemTables.setRNew(EB.ATM19.BIN.CARD.NUM,Y.INFO.BIN)
*            R.NEW(EB.ATM19.CARD.NO) = R.CARD<JBCARD.INFO.CARD.NO>
            EB.SystemTables.setRNew(EB.ATM19.CARD.NO, Y.INFO.CARD.NO)
*            R.NEW(EB.ATM19.TO.DATE) = R.CARD<JBCARD.INFO.EXPIRE.DATE>
            EB.SystemTables.setRNew(EB.ATM19.TO.DATE, Y.INFO.EXPIRE.DATE)
        END
    
* IF R.NEW(EB.ATM19.REQUEST.TYPE) EQ "ISSUE" THEN
        IF Y.REQUEST.TYPE EQ "ISSUE" THEN
            IF R.CARD NE '' AND Y.INFO.STATUS EQ "PENDING" THEN
* R.NEW(EB.ATM19.FROM.DATE) = R.CARD<JBCARD.INFO.ISSUE.DATE>
                EB.SystemTables.setRNew(EB.ATM19.FROM.DATE, Y.INFO.ISSUE.DATE)
            END
        END

* IF R.NEW(EB.ATM19.REQUEST.TYPE) EQ "REISSUE" THEN
        IF Y.REQUEST.TYPE EQ "REISSUE" THEN
* IF R.NEW(EB.ATM19.CARD.CLOSE.DATE) NE "" THEN
            IF Y.CARD.CLOSE.DATE NE "" THEN
* IF R.CARD NE '' AND R.CARD<JBCARD.INFO.STATUS> EQ "PENDING" THEN
                IF R.CARD NE '' AND Y.INFO.STATUS EQ "PENDING" THEN
* R.NEW(EB.ATM19.FROM.DATE) = R.CARD<JBCARD.INFO.ISSUE.DATE>
                    EB.SystemTables.setRNew(EB.ATM19.FROM.DATE, Y.INFO.ISSUE.DATE)
                END
            END
* ELSE IF R.NEW(EB.ATM19.CARD.CLOSE.DATE) EQ "" THEN
            ELSE IF Y.CARD.CLOSE.DATE EQ "" THEN
* IF R.CARD NE '' AND R.CARD<JBCARD.INFO.STATUS> EQ "PENDING" THEN
                IF R.CARD NE '' AND Y.INFO.STATUS EQ "PENDING" THEN
* R.NEW(EB.ATM19.ATTRIBUTE4) = R.CARD<JBCARD.INFO.ISSUE.DATE>
                    EB.SystemTables.setRNew(EB.ATM19.ATTRIBUTE4, Y.INFO.ISSUE.DATE)
                END

            END
        END
    END

RETURN

END

