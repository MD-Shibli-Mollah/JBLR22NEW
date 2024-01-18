SUBROUTINE TF.JBL.V.BTB.VVR.PSI.COMP
*-----------------------------------------------------------------------------
*Subroutine Description: This rtn will update the PSI address and the name.
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.IMPSIGH)
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 24/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract

    $INSERT I_F.BD.BTB.PSI.COMPANY
    $USING EB.Display
    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LETTER.OF.CREDIT="F.LETTER.OF.CREDIT"
    F.LETTER.OF.CREDIT=""
    FN.BD.BTB.PSI.COMPANY="F.BD.BTB.PSI.COMPANY"
    F.BD.BTB.PSI.COMPANY=""
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LETTER.OF.CREDIT,F.LETTER.OF.CREDIT)
    EB.DataAccess.Opf(FN.BD.BTB.PSI.COMPANY,F.BD.BTB.PSI.COMPANY)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
	Y.ID= EB.SystemTables.getIdNew()
	Y.NAME= EB.SystemTables.getComi()
	EB.DataAccess.FRead(FN.BD.BTB.PSI.COMPANY,Y.NAME,R.BD.BTB.PSI.COMPANY,F.BD.BTB.PSI.COMPANY,Y.ERR)
    IF R.BD.BTB.PSI.COMPANY THEN
        Y.NAME=R.BD.BTB.PSI.COMPANY<BD.BTB.LC.COMPANY.NAME>
        Y.ADDRESS=R.BD.BTB.PSI.COMPANY<BD.BTB.LC.COMPANY.ADDRESS>
        EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.PSI.ADDRS",Y.POS)
        EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.PSI.NAME",Y.POS1)
        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
        Y.TEMP<1,Y.POS>=Y.ADDRESS
        Y.TEMP<1,Y.POS1>=Y.NAME
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.TEMP)
	END
RETURN
*** </region>
END
