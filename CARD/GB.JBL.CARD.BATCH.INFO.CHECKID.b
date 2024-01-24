* @ValidationCode : MjotNjgxOTg2NDM4OkNwMTI1MjoxNzA0OTYwMjQ5MzQ4Om5hemloYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAxNzEwLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Jan 2024 14:04:09
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
* Description : ID CHECKING
* Author      : AVIJIT SAHA
* Date        : 21.12.2021
*-----------------------------------------------------------------------------
SUBROUTINE GB.JBL.CARD.BATCH.INFO.CHECKID
*-----------------------------------------------------------------------------
* Modification History : RETROFIT from TAFC to TAFJ
* 1)
* Date :01/01/2024
* Modification Description :
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
* Subroutine Description: This routine is used for EB.JBL.CARD.BATCH.INFO
* Subroutine Type: CHECKID
* Attached To    : EB.TABLE.PROCEDURES
* Attached As    : CHECKID
* TAFC Routine Name : JBL.CARD.BATCH.INFO.ID - R09
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
* $INSERT GLOBUS.BP I_Table
* $INSERT GLOBUS.BP I_F.ACCOUNT

    $USING AC.AccountOpening
    $INSERT I_F.EB.JBL.ATM.CARD.MGT
    $INSERT I_F.EB.JBL.CARD.BATCH.INFO
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.DataAccess
    $USING EB.LocalReferences
    
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "EB.JBL.CARD.BATCH.INFO.CHECKID Routine is found Successfully"
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
  

    FN.ACCT  = "F.ACCOUNT"
    F.ACCT   = ''
    ACC.REC = ''
    FN.ATM = "F.EB.JBL.ATM.CARD.MGT"
    F.ATM = ''
    ATM.REC = ''
    
*Y.T24.AC = COMI
    Y.T24.AC = EB.SystemTables.getComi()

    EB.DataAccess.Opf(FN.ACCT, F.ACCT)
    EB.DataAccess.Opf(FN.ATM, F.ATM)
    !DEBUG
    EB.DataAccess.FRead(FN.ACCT, Y.T24.AC, ACC.REC, F.ACCT, ERR)

    IF ACC.REC NE '' THEN
*CALL GET.LOC.REF('ACCOUNT','AC.ATM.CARD.NUM',Y.AC.ATM.CARD.NUM)
        EB.LocalReferences.GetLocRef('ACCOUNT','LT.AC.ATM.CARD.NUM',Y.AC.ATM.CARD.NUM)

* Y.ATM.ID = ACC.REC<AC.LOCAL.REF,Y.AC.ATM.CARD.NUM>
        Y.ATM.ID = ACC.REC<AC.AccountOpening.Account.LocalRef, Y.AC.ATM.CARD.NUM>

        IF Y.ATM.ID NE '' THEN
            EB.DataAccess.FRead(FN.ATM, Y.ATM.ID, ATM.REC, F.ATM, ERR)
            
*-----------------------------INIT--------VAR------------------------------------
            Y.REQUEST.TYPE = ATM.REC<EB.ATM19.REQUEST.TYPE>
            Y.CARD.STATUS = ATM.REC<EB.ATM19.CARD.STATUS>
            
            IF (Y.REQUEST.TYPE NE "ISSUE" OR Y.REQUEST.TYPE NE "REISSUE") AND Y.CARD.STATUS NE "PENDING" THEN
*                E="MISSING REQUEST ID"
                EB.SystemTables.setE("MISSING REQUEST ID")
*                CALL STORE.END.ERROR
                EB.ErrorProcessing.StoreEndError()
            END
        END
    END
    
    ELSE
        IF ACC.REC EQ '' THEN
*            E="INVALID ACCOUNT"
            EB.SystemTables.setE("INVALID ACCOUNT")
*            CALL STORE.END.ERROR
            EB.ErrorProcessing.StoreEndError()
        END
    END
    Y.VFUNCTION = EB.SystemTables.getVFunction()
    IF Y.VFUNCTION EQ 'R' THEN
*        E ="REVERSE NOT ALLOW"
        EB.SystemTables.setE("REVERSE IS NOT ALLOWED")
*        CALL STORE.END.ERROR
        EB.ErrorProcessing.StoreEndError()
    END
RETURN
END

