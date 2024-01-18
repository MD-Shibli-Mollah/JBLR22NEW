SUBROUTINE TF.JBL.V.CONF.NARRATIVE
*-----------------------------------------------------------------------------
* Descriptaion : if you don't give CONF.NARRATIVE drawing field value this routine generate
*                a text & populate the field value.
* 10/28/2020 -                            Create by   - MAHMUDUR RAHMAN UDOY,
*                                                 FDS Bangladesh Limited
* Attach Version: DRAWINGS,JBL.BTBAC
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.DataAccess
    $USING LC.Contract
    $USING EB.SystemTables
    $USING EB.LocalReferences
    $USING ST.Config

*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
INITIALISE:
    Y.MAT.DT = EB.SystemTables.getComi()
    DATE.CONV.FMT = 'D4'
    ST.Config.DieterDate(Y.MAT.DT, JBASE.CONV.DATE, DATE.CONV.FMT)
*    DIETER.DATE(EB.SystemTables.getToday(), JBASE.CONV.DATE, DATE.CONV.FMT)
RETURN
   
OPENFILE:
RETURN
   
PROCESS:
    Y.FLD.ONE = "YOUR BILL HAS BEEN ACCEPTED AND"
    Y.FLD.TWO = "MATURED FOR PAYMENT ON " : JBASE.CONV.DATE
    Y.FLD.VAL = Y.FLD.ONE:VM:Y.FLD.TWO
    Y.CONF.NARRATIVE = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrConfNarrative)
    IF Y.CONF.NARRATIVE EQ '' THEN
        EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrConfNarrative, Y.FLD.VAL)
    END
RETURN
END