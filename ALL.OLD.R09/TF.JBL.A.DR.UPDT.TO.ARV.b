SUBROUTINE TF.JBL.A.DR.UPDT.TO.ARV
*-----------------------------------------------------------------------------
*Subroutine Description: Update Drawings ID and Drawings Date In ARV Templete.
*Subroutine Type:
*Attached To    : FUNDS.TRANSFER Version (DRAWINGS,JBL.F.EXPDOCREAL)
*Attached As    : AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 08/12/2020 -                            CREATE   - SHAJJAD HOSSEN,
*                                                 FDS Bangladesh Limited
 
*-----------------------------------------------------------------------------
* Modification History :
* date  -
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.JBL.ARV
    $INSERT I_F.BD.LC.AD.CODE
*
    $USING LC.Contract
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.LocalReferences
*-----------------------------------------------------------------------------
*
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*****
INIT:
*****
    FN.JBL.ARV = 'F.JBL.ARV'
    F.JBL.ARV = ''
    
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.ARV.NO",Y.ARV.NO)
RETURN
**********
OPENFILES:
**********
    EB.DataAccess.Opf(FN.JBL.ARV, F.JBL.ARV)
RETURN
********
PROCESS:
********
    Y.DR.ID = EB.SystemTables.getIdNew()
    Y.DR.DATE = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrValueDate)

    Y.FT.ID =EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.ARV.NO>
    
    EB.DataAccess.FRead(FN.JBL.ARV, Y.FT.ID, R.JBL.ARV, F.JBL.ARV, JBL.ARV.ERR)
*    RECORD WRITE IN JBL.ARV APPLICATION
    R.JBL.ARV<ARV.DRAWINGS.ID> = Y.DR.ID
    R.JBL.ARV<ARV.DRAWINGS.DT> = Y.DR.DATE
    EB.DataAccess.FWrite(FN.JBL.ARV, Y.FT.ID, R.JBL.ARV)
RETURN
END
