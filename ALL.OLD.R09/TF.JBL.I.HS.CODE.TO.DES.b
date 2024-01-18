SUBROUTINE TF.JBL.I.HS.CODE.TO.DES
*-----------------------------------------------------------------------------
*Subroutine Description: HS code description update for PI
*Subroutine Type:
*Attached To    : JBL.PI,JBL,INPUT
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 01/09/2020 -                            Create   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING EB.Display
    $USING LC.Contract
    $USING ST.Config
    $USING EB.Updates
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
    
    $INSERT I_F.BD.HS.CODE.LIST
    $INSERT I_F.JBL.PI
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.HS.CODE.LIST = 'F.BD.HS.CODE.LIST'
    F.HS.CODE.LIST = ''
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.HS.CODE.LIST,FV.HS.CODE.LIST)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.HS.CODES = EB.SystemTables.getRNew(PI.HS.CODE)
    Y.HS.VM.C =DCOUNT(Y.HS.CODES,@VM)
    Y.HS.VM.M = 1

    LOOP
        Y.HS.CODES.VM.P = FIELD(Y.HS.CODES,@VM,Y.HS.VM.M)

        Y.HS.SM.C =DCOUNT(Y.HS.CODES.VM.P,@SM)
        Y.HS.SM.M = 1
            
        LOOP
            Y.HS.CODES.SM.P = FIELD(Y.HS.CODES.VM.P,@SM,Y.HS.SM.M)

            EB.DataAccess.FRead(FN.HS.CODE.LIST, Y.HS.CODES.SM.P, R.HS.CODE, F.HS.CODE.LIST, HS.ERR)

            IF R.HS.CODE THEN
                Y.DES = R.HS.CODE<HS.CO.DESCRIPTION>

                IF EB.SystemTables.getApplication() EQ "JBL.PI" THEN
                    CONVERT FM TO '*' IN Y.DES
                    CONVERT VM TO '*' IN Y.DES
                    CONVERT SM TO '*' IN Y.DES
                    
                    Y.TEMP = EB.SystemTables.getRNew(PI.COMMODITY)
                    
                    IF Y.TEMP<1,Y.HS.VM.M,Y.HS.SM.M> EQ "" THEN
                        Y.TEMP<1,Y.HS.VM.M,Y.HS.SM.M> = FIELD(Y.DES ,'*',1)
                    END

                    EB.SystemTables.setRNew(PI.COMMODITY, Y.TEMP)
                END

            END
            
            IF Y.HS.SM.M GE Y.HS.SM.C THEN BREAK ;* check the status at the end of the loop
            Y.HS.SM.M++
        REPEAT
            
        IF Y.HS.VM.M GE Y.HS.VM.C THEN BREAK ;* check the status at the end of the loop
        Y.HS.VM.M++
    REPEAT
    
    
RETURN
*** </region>
*****************************************************

********************************************************

END
