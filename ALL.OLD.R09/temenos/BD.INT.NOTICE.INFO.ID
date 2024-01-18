* @ValidationCode : MjoyMTA4OTc4OTA2OkNwMTI1MjoxNjQ5MzIwODcyNTE5Om50ZWNoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 07 Apr 2022 15:11:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ntech
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
SUBROUTINE BD.INT.NOTICE.INFO.ID
*-----------------------------------------------------------------------------
    !** FIELD definitions FOR BD.INT.NOTICE.INFO
*!
*Developer Info:
*    Date         : 30/03/2022
*    Description  : ID Routine for the BD.INT.ACCOUNT.VIOINFO template
*    Developed By : Md. Tajul Islam
*    Designation  : Software Engineer
*    Email        : tajul.ntl@nazihargroup.com
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------
* TODO Add logic to validate the id
* TODO Create an EB.ERROR record if you are creating a new error code
*-----------------------------------------------------------------------------
    IF (OFS$OPERATION EQ 'VALIDATE' OR OFS$OPERATION EQ 'PROCESS') THEN
        
        RETURN
    END

    IF EB.SystemTables.getVFunction() EQ 'I' THEN
        GOSUB INIT
        GOSUB PROCESS
    END
RETURN
    
INIT:
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    Y.ID = EB.SystemTables.getIdNew()
    Y.TODAY=EB.SystemTables.getToday()
    R.ACC.REC=''
RETURN
*
PROCESS:
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
    EB.DataAccess.FRead(FN.ACCOUNT, Y.ID, R.ACC.REC,F.ACCOUNT, ERR)
    IF R.ACC.REC EQ '' THEN
        EB.SystemTables.setE('Enter a Valid Account Number')
    END
    
RETURN
RETURN