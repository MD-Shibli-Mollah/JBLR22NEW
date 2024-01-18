SUBROUTINE TF.JBL.A.FT.UPDT.TO.DR
*-----------------------------------------------------------------------------
*Subroutine Description: Writing FT id in drawing for OFS add payment
*Attached To    : FUNDS.TRANSFER Version (FUNDS.TRANSFER,BD.BTB.SETTLE)
*Attached As    : AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 17/12/2019 -                            CREATE   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $USING LC.Contract
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING FT.Contract
    $USING EB.Updates
*-----------------------------------------------------------------------------
*
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*****
INIT:
*****
    FN.DRAW = 'F.DRAWINGS'
    F.DRAW = ''
    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    
    APPLICATION.NAMES = 'DRAWINGS':FM:'FUNDS.TRANSFER'
    LOCAL.FIELDS = 'LT.FT.REF.NO':FM:'LT.FT.DR.REFNO'
    EB.Updates.MultiGetLocRef(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
    Y.FT.REF.NO.POS = FLD.POS<1,1>
    Y.FT.DR.REFNO.POS = FLD.POS<2,1>
RETURN
**********
OPENFILES:
**********
    EB.DataAccess.Opf(FN.FT,F.FT)
    EB.DataAccess.Opf(FN.DRAW,F.DRAW)
RETURN
********
PROCESS:
********
    Y.FT.ID = EB.SystemTables.getIdNew()

    EB.DataAccess.FRead(FN.FT,Y.FT.ID,R.FT,F.FT,FT.ERR)
    Y.FT.LOC.FLD.VAL = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.DR.ID = Y.FT.LOC.FLD.VAL<1,Y.FT.DR.REFNO.POS>
    
    
    EB.DataAccess.FRead(FN.DRAW,Y.DR.ID,DR.REC,F.DRAW,E.DR)
    DR.REC<LC.Contract.Drawings.TfDrLocalRef,Y.FT.REF.NO.POS> = Y.FT.ID

    WRITE DR.REC ON F.DRAW,Y.DR.ID
RETURN

END
