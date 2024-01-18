SUBROUTINE TF.JBL.I.FT.INWR.STS.CHK
*-----------------------------------------------------------------------------
*Subroutine Description: HS code validation for ARV
*Subroutine Type:
*Attached To    : FUNDS.TRANSFER  Version (FUNDS.TRANSFER,JBL.IT.FCYNOSTO.FTHP)
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 06/01/2020 -                            CREATE   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.HS.CODE.LIST
*
    $USING LC.Contract
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING FT.Contract
    $USING ST.Customer
    $USING EB.Foundation
    $USING EB.TransactionControl
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
*-----------------------------------------------------------------------------
*
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*****
INIT:
*****
    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    FN.BD.HS.CODE.LIST = 'F.BD.HS.CODE.LIST'
    F.BD.HS.CODE.LIST = ''
    
    APPLICATION.NAMES = 'FUNDS.TRANSFER'
    LOCAL.FIELDS = 'LT.CMDITY.CODE'
    EB.Foundation.MapLocalFields(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
    Y.LT.CMDITY.CODE.POS = FLD.POS<1,1>
RETURN
**********
OPENFILES:
**********
    EB.DataAccess.Opf(FN.FT, F.FT)
    EB.DataAccess.Opf(FN.BD.HS.CODE.LIST, F.BD.HS.CODE.LIST)
RETURN
********
PROCESS:
********
    Y.CMDITY.CODE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1, Y.LT.CMDITY.CODE.POS>
    CONVERT SM TO VM IN Y.CMDITY.CODE
    Y.CMDITY.COUNT = DCOUNT(Y.CMDITY.CODE,VM)
    
    
    Y.OVERRIDE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.Override)
    CONVERT SM TO VM IN Y.OVERRIDE
    Y.OVR.COUNT = DCOUNT(Y.OVERRIDE,VM)
    
    FOR I=1 TO Y.CMDITY.COUNT
        Y.HS.CODE.ID = Y.CMDITY.CODE<1,I>

        EB.DataAccess.FRead(FN.BD.HS.CODE.LIST, Y.HS.CODE.ID, R.BD.HS.CODE.LIST, F.BD.HS.CODE.LIST, BD.HS.CODE.LIST.ERR)

        IF R.BD.HS.CODE.LIST THEN
            Y.STATUS = R.BD.HS.CODE.LIST<HS.CO.STATUS>
            Y.CLAUSE = R.BD.HS.CODE.LIST<HS.CO.SPCL.PRMSN.CLAUSE>
            
            IF Y.STATUS EQ "RESTRICTED" THEN
                Y.OVR.COUNT += '1'
                EB.SystemTables.setAf(FT.Contract.FundsTransfer.LocalRef)
                EB.SystemTables.setAv(Y.LT.CMDITY.CODE.POS)
                EB.SystemTables.setText("HS CODE ":Y.HS.CODE.ID:" RESTRICTED, ":Y.CLAUSE)
                EB.OverrideProcessing.StoreOverride(Y.OVR.COUNT)
            END
            IF Y.STATUS EQ "PROHIBITED" THEN
                EB.SystemTables.setAf(FT.Contract.FundsTransfer.LocalRef)
                EB.SystemTables.setAv(Y.LT.CMDITY.CODE.POS)
                EB.SystemTables.setEtext("PROHIBITED BY: ":Y.CLAUSE)
                EB.ErrorProcessing.StoreEndError()
            END
        END ELSE
            EB.SystemTables.setAf(FT.Contract.FundsTransfer.LocalRef)
            EB.SystemTables.setAv(Y.LT.CMDITY.CODE.POS)
            EB.SystemTables.setEtext("HS code not valid")
            EB.ErrorProcessing.StoreEndError()
        END
    NEXT I
          
RETURN


END


