SUBROUTINE TF.JBL.V.CAL.US.MAT.DATE
*-----------------------------------------------------------------------------
*Subroutine Description: Maturity Date Calculation
*Attached To    : DRAWINGS Version (DRAWINGS,JBL.IMPAC,DRAWINGS,JBL.BTBAC)
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 23/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $USING EB.LocalReferences
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.API
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    Y.ACC.DATE = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrValueDate)
    Y.SHIP.DATE = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrShipmentDate)
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.NEG.DATE",Y.NEG.POS)
    Y.NEG.DATE = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.NEG.POS>
    
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.MAT.DATE",Y.MAT.POS)
    Y.MAT.DATE = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.MAT.POS>
    
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.TENR.DAYS",Y.TENOR.POS)
    Y.TENOR.DAYS = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.TENOR.POS>
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.MAT.CALC = EB.SystemTables.getComi()
    
    IF Y.TENOR.DAYS EQ "AT SIGHT" THEN
        Y.TENOR.DAYS = "21"
    END
    Y.NEW.TENOR.DAYS = Y.TENOR.DAYS + "180"
    
    Y.BASE.DATE = ""
    BEGIN CASE
        CASE Y.MAT.CALC EQ "ACCEPTANCE DATE"
            IF Y.ACC.DATE EQ "" THEN RETURN
            Y.BASE.DATE = Y.ACC.DATE
        CASE Y.MAT.CALC EQ "SHIPMENT DATE"
            IF Y.SHIP.DATE EQ "" THEN RETURN
            Y.BASE.DATE = Y.SHIP.DATE
        CASE Y.MAT.CALC EQ "NEGOTIATION DATE"
            IF Y.NEG.DATE EQ "" THEN RETURN
            Y.BASE.DATE = Y.NEG.DATE
    END CASE
    
    IF Y.BASE.DATE EQ "" THEN RETURN
    
    IF Y.MAT.DATE EQ "" THEN
        Y.BASE.DATE.TEMP = Y.BASE.DATE
        EB.API.Cdt("",Y.BASE.DATE.TEMP,Y.TENOR.DAYS:"C")
        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)
        Y.TEMP<1,Y.MAT.POS> = Y.BASE.DATE.TEMP
        EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, Y.TEMP)
    END
    IF EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrMaturityReview) EQ "" THEN
        Y.BASE.DATE.TEMP = Y.BASE.DATE
        EB.API.Cdt("", Y.BASE.DATE.TEMP, Y.NEW.TENOR.DAYS:"C")
        EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrMaturityReview , Y.BASE.DATE.TEMP)
    END

RETURN

*** </region>
END
