SUBROUTINE TF.JBL.I.CONF.NARRATIVE.AT.POPU
*-----------------------------------------------------------------------------
* Modification History :
* 11-02-2021 -                            Retrofit   - SHAJJAD HOSSEN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.DataAccess
    $USING LC.Contract
    $USING EB.SystemTables
    $USING EB.LocalReferences
    $USING ST.Config
    $USING EB.Updates

*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
INITIALISE:
    FLD.POS = ''
    APPLICATION.NAME ='DRAWINGS'
    LOCAL.FIELD = 'LT.TF.MAT.DATE'
    EB.Updates.MultiGetLocRef(APPLICATION.NAME,LOCAL.FIELD,FLD.POS)
    Y.MT.DT.POS = FLD.POS<1,1>
    Y.FLD.VAL = 0
*    DIETER.DATE(EB.SystemTables.getToday(), JBASE.CONV.DATE, DATE.CONV.FMT)
RETURN
   
OPENFILE:
RETURN
   
PROCESS:
    Y.MT.DT = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.MT.DT.POS>
    DATE.CONV.FMT = 'D4'
    ST.Config.DieterDate(Y.MT.DT, JBASE.CONV.DATE, DATE.CONV.FMT)

    Y.FLD.ONE = "YOUR BILL HAS BEEN ACCEPTED AND"
    Y.FLD.TWO = "MATURED FOR PAYMENT ON " : JBASE.CONV.DATE
    Y.FLD.VAL = Y.FLD.ONE:VM:Y.FLD.TWO
    Y.CONF.NARRATIVE = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrConfNarrative)
    IF Y.CONF.NARRATIVE EQ '' THEN
        EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrConfNarrative, Y.FLD.VAL)
    END
RETURN
END
