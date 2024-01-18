SUBROUTINE TF.JBL.V.LC.CNTRY.CODE.DEF.RTN
*-----------------------------------------------------------------------------
*Subroutine Description: Set Country Origin Field Value in LC by Country Code wise
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
    $USING EB.LocalReferences
    $USING EB.SystemTables
    
*$INSERT I_F.BD.COUNTRY.CODE
    
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    Y.CTY.CODE = EB.SystemTables.getComi()
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT",'LT.TF.CTRY.CODE',Y.CTY.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT",'LT.TF.CTRY.ORGN',Y.CTY.ORIG.POS)
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
    IF Y.CTY.CODE EQ 'IISC' THEN
        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
        Y.TEMP<1,Y.CTY.POS> = '9999'
        Y.TEMP<1,Y.CTY.ORIG.POS> = 'BD'
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.TEMP)
    END
    IF Y.CTY.CODE EQ 'IZCS' THEN
        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
        Y.TEMP<1,Y.CTY.POS> = '2998'
        Y.TEMP<1,Y.CTY.ORIG.POS> = 'BD'
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.TEMP)
    END
RETURN
*** </region>

END
