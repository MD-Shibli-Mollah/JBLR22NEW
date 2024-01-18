* @ValidationCode : MjotMTUzMjI4NDMzMDpDcDEyNTI6MTU3MzQ3MTMyMzU1NzpERUxMOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjE3X0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Nov 2019 17:22:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : DELL
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R17_AMR.0
SUBROUTINE TF.JBL.V.SCT.CAPTURE
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.SCT.CAPTURE
    $INSERT I_F.BD.BTB.JOB.REGISTER
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.ErrorProcessing

    GOSUB PROCESS
RETURN

PROCESS:
    BEGIN CASE
        CASE EB.SystemTables.getAf() EQ '27'
****** 27 is the field position of field SCT.NEW.EXIST.JOB.NO
            IF EB.SystemTables.getComi() EQ 'EXIST' THEN
                EB.SystemTables.setRNew(SCT.JOB.CURRENCY, "")
                T(SCT.JOB.CURRENCY)<3>='NOINPUT'
                T(SCT.BTB.JOB.NO)<3>=''
                N(SCT.BTB.JOB.NO)='35.1'
                Y.JOB.NUMBER = EB.SystemTables.getRNew(SCT.BTB.JOB.NO)
                Y.BEN.CUS.NO = EB.SystemTables.getRNew(SCT.BENEFICIARY.CUSTNO)
                Y.JOB.CUSTOMER = FIELD(Y.JOB.NUMBER,'.',2)
            END ELSE
                T(SCT.BTB.JOB.NO)<3>='NOINPUT'
                EB.SystemTables.setRNew(SCT.BTB.JOB.NO, "")
                IF EB.SystemTables.getRNew(SCT.JOB.CURRENCY) EQ '' THEN
                    EB.SystemTables.setRNew(SCT.JOB.CURRENCY,'USD')
                END
            END
        CASE EB.SystemTables.getAf() EQ '28'
****** 28 is the field position of field SCT.BTB.JOB.NO
*To check 1. job customer number and sct customer 2. job currency and sct currency
            IF EB.SystemTables.getRNew(SCT.NEW.EXIST.JOB.NO) EQ 'EXIST' THEN
                Y.JOB.NUMBER = EB.SystemTables.getComi()
                Y.BEN.CUS.NO = EB.SystemTables.getRNew(SCT.BENEFICIARY.CUSTNO)
                Y.JOB.CUSTOMER = FIELD(Y.JOB.NUMBER,'.',2)
                IF Y.BEN.CUS.NO NE Y.JOB.CUSTOMER THEN
                    EB.SystemTables.setAf(SCT.BTB.JOB.NO)
                    EB.SystemTables.setEtext('JOB NO NOT BELONGS TO BENEFICIARY')
                    EB.ErrorProcessing.StoreEndError()
                    RETURN
                END

                FN.BD.BTB.JOB.REGISTER = 'F.BD.BTB.JOB.REGISTER'
                F.BD.BTB.JOB.REGISTER = ''
                EB.DataAccess.Opf(FN.BD.BTB.JOB.REGISTER, F.BD.BTB.JOB.REGISTER)
                EB.DataAccess.FRead(FN.BD.BTB.JOB.REGISTER, Y.JOB.NUMBER, REC.JOB.REG, F.BD.BTB.JOB.REGISTER, ERR.JOB.REG)
                Y.JOB.CCY = REC.JOB.REG<BTB.JOB.JOB.CURRENCY>
                EB.SystemTables.setRNew(SCT.JOB.CURRENCY, Y.JOB.CCY)

*                Y.SCT.CCY = EB.SystemTables.getRNew(SCT.CURRENCY)
*                IF Y.SCT.CCY NE Y.JOB.CCY THEN
*                    EB.SystemTables.setAf(SCT.BTB.JOB.NO)
*                    EB.SystemTables.setEtext('SALSE CONTRACT AND JOB CURRENCY ARE MISSMATCH')
*                    EB.ErrorProcessing.StoreEndError()
*                    RETURN
*                END
            END
    END CASE
RETURN

END
