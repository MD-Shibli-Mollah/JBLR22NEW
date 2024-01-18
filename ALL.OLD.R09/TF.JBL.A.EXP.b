SUBROUTINE TF.JBL.A.EXP
*-----------------------------------------------------------------------------
*Subroutine Description: Keep track of export LC in JBL.EXP
*Subroutine Type:
*Attached To    : DRAWINGS VERSION (DRAWINGS,F.EXPCOLL)
*Attached As    : AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 05/02/2020 -                            CREATE   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.JBL.EXP
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING LC.Contract
    $USING EB.Foundation
    
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.JBL.EXP = "F.JBL.EXP"
    F.JBL.EXP = ""
    FN.DR = "F.DRAWINGS"
    F.DR = ""
    EB.Foundation.MapLocalFields("DRAWINGS", "LT.TF.APL.CUSNO", Y.CUS.POS)
    EB.Foundation.MapLocalFields("DRAWINGS", "LT.EXPORT.DT", Y.EXPORT.DATE.POS)
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.JBL.EXP, F.JBL.EXP)
*    EB.DataAccess.Opf(FN.DR, F.DR)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>

    Y.DRAW.ID = EB.SystemTables.getIdNew()
    Y.CUS.ID = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1, Y.CUS.POS>
    
    Y.EXPORT.DATE = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1, Y.EXPORT.DATE.POS>
    Y.DR.TYPE = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDrawingType)
    

    EB.DataAccess.FRead(FN.JBL.EXP, Y.CUS.ID, R.JBL.EXP, F.JBL.EXP, Y.JBL.EXP.ERR)
    IF R.JBL.EXP THEN
        LOCATE Y.DRAW.ID IN R.JBL.EXP SETTING Y.STOCK.CNT ELSE Y.STOCK.CNT = DCOUNT(R.JBL.EXP<EXP.DRAWINGS.ID>,VM)+1
    

        R.JBL.EXP<EXP.DRAWINGS.ID, Y.STOCK.CNT> = Y.DRAW.ID
        R.JBL.EXP<EXP.EXPORT.DATE, Y.STOCK.CNT> = Y.EXPORT.DATE
        R.JBL.EXP<EXP.DRAWINGS.TYPE, Y.STOCK.CNT> = Y.DR.TYPE
        
        EB.DataAccess.FWrite(FN.JBL.EXP, Y.CUS.ID, R.JBL.EXP)
    END
RETURN
*** </region>

END