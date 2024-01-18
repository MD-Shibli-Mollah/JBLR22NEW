SUBROUTINE TF.JBL.V.LC.COUNTRY.ORIGIN
*-----------------------------------------------------------------------------
*Subroutine Description: Write Country Name from BD.COUNTRY.CODE to LC
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
    $USING LC.Contract
    $INSERT I_GTS.COMMON
    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING EB.Display
    $USING ST.Config
    $USING EB.Updates
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $INSERT I_F.BD.COUNTRY.CODE
    
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    ENRI=''
    Y.CNT =''
    Y.AF.POS = LC.Contract.LetterOfCredit.TfLcLocalRef
    Y.CC.CODE = EB.SystemTables.getComi()
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
   
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    IF R.CC.CODE THEN
        EB.DataAccess.CacheRead('F.BD.COUNTRY.CODE',Y.CC.CODE,R.CC.CODE,F.ERR)
        EB.LocalReferences.GetLocRef('LETTER.OF.CREDIT','LT.TF.CTRY.CODE',Y.CC.POS)
        
        Y.NAME.ENR=R.CC.CODE<BDCODE.COUNTRY.NAME>

        ENRI=Y.NAME.ENR
        IF ENRI THEN
            OFS.ENRI<Y.AF.POS,Y.CC.POS,Y.CNT> = ENRI
            OFS.ENRI<Y.AF.POS,Y.CC.POS,Y.CNT> = ENRI

        END
        CALL REBUILD.SCREEN
    END
RETURN
*** </region>
END
