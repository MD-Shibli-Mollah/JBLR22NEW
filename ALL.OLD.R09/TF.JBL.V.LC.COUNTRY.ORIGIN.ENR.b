SUBROUTINE TF.JBL.V.LC.COUNTRY.ORIGIN.ENR
RETURN
*-----------------------------------------------------------------------------
*Subroutine Description: Country Origin Enrichment
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
$USING EB.DataAccess
$USING EB.LocalReferences
$USING EB.Display
$USING LC.Contract
$USING ST.Config
$USING EB.SystemTables
*-----------------------------------------------------------------------------
GOSUB INITIALISE ; *INITIALISATION
GOSUB OPENFILE ; *FILE OPEN
GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.COUN='F.COUNTRY'
    F.COUN=''
    
    SEL.CMD=''
    SEL.LIST=''
    CAL.REC=''
    Y.ERROR=''
    R.UNIT=''
    Y.ERR=''
    
    Y.CC.POS1=''
    ENRI=''
    Y.CNT =''
    Y.AF.POS = LC.Contract.LetterOfCredit.TfLcLocalRef
    Y.CC.ORGIN = EB.SystemTables.getComi()
    SEL.CMD = "SELECT ":FN.COUN: " WITH SHORT.NAME EQ ":Y.CC.ORGIN
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',CAL.REC,Y.ERROR)
    EB.DataAccess.FRead(FN.COUN,SEL.LIST,R.UNIT,R.UNIT,Y.ERR)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
	IF R.UNIT THEN
        EB.LocalReferences.GetLocRef('LETTER.OF.CREDIT','LT.TF.CTRY.ORGN',Y.CC.POS1)
	    Y.NAME.ENR=R.UNIT<ST.Config.Country.EbCouShortName>
	
	    ENRI=Y.NAME.ENR
	    IF ENRI THEN
	        OFS.ENRI<Y.AF.POS,Y.CC.POS1,Y.CNT> = ENRI
	        OFS.ENRI<Y.AF.POS,Y.CC.POS1,Y.CNT> = ENRI
	    END
	    EB.Display.RebuildScreen()
	END
RETURN
*** </region>

END

