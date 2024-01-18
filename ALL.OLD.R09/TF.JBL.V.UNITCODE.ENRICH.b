SUBROUTINE TF.JBL.V.UNITCODE.ENRICH
*-----------------------------------------------------------------------------
*Subroutine Description: Unit Code Enrichment Comparing with BD.LC.UNITCODE
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.IMPSIGH)
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 22/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INCLUDE I_GTS.COMMON
    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING EB.Display
    $USING LC.Contract
    $USING EB.Updates
    $USING EB.SystemTables
    $INCLUDE I_F.BD.LC.UNITCODE
*-----------------------------------------------------------------------------
    IF EB.SystemTables.getComi() EQ '' THEN RETURN
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.UN = 'F.BD.LC.UNITCODE'
    F.UN = ''
    ENRI = ''
    Y.CNT =''
    Y.AF.POS = LC.Contract.LetterOfCredit.TfLcLocalRef
*    Y.APP = 'LETTER.OF.CREDIT'
    Y.APP=EB.SystemTables.getApplication()
    Y.FLD = "LT.TF.COMMO.UN"
    EB.Updates.MultiGetLocRef(Y.APP, Y.FLD, Y.POS)
    Y.TOTAL.POS = Y.POS<1,1>
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.UN,F.UN)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.UNIT.NAME = EB.SystemTables.getComi()
    SEL.CMD = "SELECT ":FN.UN: " WITH UNIT.SHORT.NAME EQ ":Y.UNIT.NAME
*    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',CAL.REC,Y.ERROR)
    EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',CAL.REC,Y.ERROR)
    
    EB.DataAccess.FRead(FN.UN,SEL.LIST,R.UNIT,F.UN,Y.ERR)
*    CALL F.READ(FN.UN,SEL.LIST,R.UNIT,R.UNIT,Y.ERR)
    IF R.UNIT THEN
        Y.NAME = R.UNIT<BD.UNIT.SHORT.NAME>
        Y.DESC = R.UNIT<BD.UNIT.DESCRIPTION>
        IF Y.UNIT.NAME EQ Y.NAME  THEN
            ENRI=Y.DESC
            IF ENRI THEN
                OFS.ENRI<Y.AF.POS,Y.TOTAL.POS,Y.CNT> = ENRI
                OFS$ENRI<Y.AF.POS,Y.TOTAL.POS,Y.CNT> = ENRI
            END
        END
    END
RETURN

RETURN
*** </region>

END
