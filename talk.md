# PowerShell - Not Just Windows Anymore!

Up until this point, we've refered to PowerShell as a thing that can only be used to manage Windows hosts, and nothing more. It's always `if linux:bash`, `if windows:powershell`. But with PowerShell Core you can do more! Wait...did I just rhyme? And on the title slide too. Oh the shame...

## PowerShell Release History

So, the cliche still applies: you need to know where you've been in order to know where you're going. PowerShell started out with v1 in 2006 and had an almost yearly cadence up until version 5 in 2016, with varying OS support, but still only for Windows operating systems. In 2018 PowerShell Core was released and was the first version of PowerShell that supported more platforms than Windows, along with the ability to install multiple versions side-by side! PowerShell Core 6.1 came along and brought the .NET Core version up to 2.1 which would be a LTS release. 6.2 will be released soon, with a 24% faster startup time.

Wait, hold the phone. What's .NET CORE? Why is it called PowerShell Core? What does all of this mean?

## PowerShell Core- A Very Different PowerShell

https://docs.microsoft.com/en-us/powershell/scripting/whats-new/what-s-new-in-powershell-core-61?view=powershell-6

.NET Core is a cross platform, open source re-implementation of the .NET Framework. Where the .NET Framework was a huge library of classes and frameworks that for the most part only worked on Windows, .NET Core is a smaller set of tools and libraries that cover a broad set of functionality that use the native APIS of the multiple platforms it supports.

This allowed the PowerShell team to port most of the PowerShell engine over and gain the ability to run PowerShell on multiple platforms, without changing much of the surface API you use. However, you can't re-implement everything all at once, so there are some things missing and some things aren't fully implemented. This represents an almost entirely different product, and as such a new name for the executable: pwsh. This means there are now two products: Windows PowerShell and PowerShell Core. Windows PowerShell will be pinned at 5.1, and only have security or major bugfixes released. All new features and new work will be devoted to PowerShell Core.

What new features you may ask? Besides being able to run PowerShell in a Linux terminal? Let’s see

## Cross-Platform - Finally! But What about Windows?

It's all well and good that PowerShell does more than Windows now (oh boy is that joke tired) but we know that since this was almost-but-not-quite a full re-write did we lose anything on Windows? we lost some things intially, enough to make you pause jumping into it when it was at v6.0, but not enough to start using it side-by-side now that it's v6.1.

It does support Windows still, and still has all the cmdlets you have come to know and love. However out of the gate, not all existing PowerShell Modules were suported by v6.0. All of the built-in modules were ported and worked, but flagship modules like Active Directory, Exchange, and SQL did not. Most modules were using Windows-only APIS like COM, DCOM, raw .NET calls that aren't in .NET Core, etc. Eventually most modules would support PowerShell Core, but in the interim it was hard to get your work done.

## Daily Use - Profile Differences

If you are familiar with Windows PowerShell, you know all the different profiles you can have:

```
PS C:\Users\james> $profile | fl * -for

AllUsersAllHosts       : C:\Program Files\PowerShell\6-preview\profile.ps1
AllUsersCurrentHost    : C:\Program Files\PowerShell\6-preview\Microsoft.PowerShell_profile.ps1
CurrentUserAllHosts    : C:\Users\james\Documents\PowerShell\profile.ps1
CurrentUserCurrentHost : C:\Users\james\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

On Mac and Linux, they are in slightly different places:

```
PS /home/james> $profile | fl * -for

AllUsersAllHosts       : /opt/microsoft/powershell/6/profile.ps1
AllUsersCurrentHost    : /opt/microsoft/powershell/6/Microsoft.PowerShell_profile.ps1
CurrentUserAllHosts    : /home/james/.config/powershell/profile.ps1
CurrentUserCurrentHost : /home/james/.config/powershell/Microsoft.PowerShell_profile.ps1
```

Notice the `.config` directory. That may seem strang if you aren't familair with the XDG Base Directory Specification https://docs.microsoft.com/en-us/powershell/scripting/whats-new/what-s-new-in-powershell-core-60?view=powershell-6#filesystem

## Daily Use - Where are my Modules? What Modules can I use?

During the 6.0 there were several ways to 'make' a module work on PowerShell core by editing PSModulePath and using 'SkipEditionCheck' but they really didn't work reliably. This was a known problem, so there's a solution... right?

Enter the WindowsCompatibility Module. This module lets PowerShell Core access Windows PowerShell Modules that are not yet natively available on PowerShell Core. How can it do that if the module isn't supported? Through the power of Implicit Remoting! This feature has been around since v2, but isn't used as much as it should. It uses PowerShell Remoting to provide wrapper cmdlets and functions that serialize the requests and responses to allow PowerShell Core.

All good right? Well, this is a solution for Windows so it doesn't run on other platforms as it uses WinRM. Since its a serialized remoting approach, no GUI applications or use of WPF or Windows Forms. It also requires the latest version of PowerShell Core v6.1.

Even with all of the caveats, this is a major improvement and lights up Modules that aren't strictly supported. This is an important bridge to the time when the Module finally becomes PowerShell Core compliant.

To indicate whether a given PowerShell module could run in PowerShell Core, the module manifest was extended to include a `CompatiblePSEditions` property. Modules that have a value of `Core` will support PowerShell core, modules that have `Desktop` cannot support PowerShell core at this time. Any Module installed `with` PowerShell Core will skip the check and show as available.

## Daily Use - WindowsCompatibility

Enter the WindowsCompatibility Module. This module lets PowerShell Core access Windows PowerShell Modules that are not yet natively available on PowerShell Core. How can it do that if the module isn't supported? Through the power of Implicit Remoting! This feature has been around since v2, but isn't used as much as it should. It uses PowerShell Remoting to provide wrapper cmdlets and functions that serialize the requests and responses to allow PowerShell Core.

All good right? Well, this is a solution for Windows so it doesn't run on other platforms as it uses WinRM. Since its a serialized remoting approach, no GUI applications or use of WPF or Windows Forms. It also requires the latest version of PowerShell Core v6.1.

Even with all of the caveats, this is a major improvement and lights up Modules that aren't strictly supported. This is an important bridge to the time when the Module finally becomes PowerShell Core compliant.

## Notes from The Field

Ok, we're gotten past the shiny new cross platform stuff and some of the gotchas, what are some things to be aware using PowerShell Core?

## Notes from The Field - Platform Detection
## Notes from The Field - Restricting to Platforms
## Notes from The Field - Aliases are not your Friend

If you've been a PowerShell user for any length of time, you've used aliases in the terminal and in scripts. You've developed opinions on their use and when to use them, and reconized that the community has a large array of opinions on whether or not to use them. PowerShell Core in general, and it's multi-platform nature, makes this even harder.

- Some aliases conflicted with names of standrd Unix utilities (ls, cat, curl)
- Some aliases (ls, cat) now mean different things on different platforms

RFC #129 - https://github.com/PowerShell/PowerShell-RFC/pull/129 has initial discussions on removing and/or dealing with aliases.

Issue 8970 https://github.com/PowerShell/PowerShell/issues/8970 is among many asking for decouple/removal.

## Notes from The Field - When to use shebangs

why? tells the computer what language the script is written in, and the path to the interpreter on the system that can execute the commands contained within.

Ensure pwsh is in PATH
Use the interpreter directive `#!/usr/bin/env pwsh`
Always use Unix-style line endings (more on this later)

Why again? Git hooks on windows

## Notes from The Field - Environment Variables

Environment variables are case-sensitive on macOS and Linux, so the casing of the PSModulePath environment variable has been standardized. (#3255) Import-Module is case insensitive when it's using a file path to determine the module's name. (#5097)

## Notes from The Field - Platform Variables

Ok, so PowerShell Core may have alot of smarts built in to detect and handle different platforms, but what if you really really need to know what platform you're running on in order to do something? PowerShell Core has you covered with some built-in variables that are automatically populated for each platform it supports.

What would you use these for if PowerShell cmdlets know this stuff? This is for the custom logic needed for your environment. You would use these for locations for binaries or determining which command to run depending on the OS. This avoids having to know how to query CIM for the Windows OS or uname for linux, for simple switch or if-else statements. This won't work for more complicated scenarios where you need to know which linux distribution you're running in, or whether you're running on 2012R2 or 2016. When you get to those scenarios, drop down to the raw query commands.

## Notes from The Field - File Encoding

It used to be, you didn't have to worry about encoding much if you only worked on one platform. With the advent of multi-lingual and accesible interfaces that is no longer the case, and greater support for multiple character sets in needed. this is a large subject.

UTF-8 is the best choice for cross platform, with ASCII being your last best hope.

UTF-8 is readable by most modern applications, and handles the most characters in a predicatble way.
ASCII is the best fallback for interop, as it restricts what characters it supports so less things go wrong.

If you set the default parameters for cmdlets that use encoding like `PSDefaultParameterValues["Out-File:Encoding"] = "UTF8"` in your profile or at the begining of your scripts, you can avoid having to remember to set encoding correctly for cmdlets that use encoding.

## Notes from The Field - File Newlines and Line Endings

Most Mac and Windows applications will accept `\n` but Unix shell interpreters will fail to read `\r\n`. This is especially important in the shebang, as it will prevent the entire file from being read instead of just having wierdly terminated lines in output.

If you are writing scripts that will be read and/or executed on multiple platforms you will have to start standardizing on Unix-style linefeeds. It ensures that all platforms will read and understand your text, and most modern editors allow you to configure linefeed defaults. This, among many other reasons, is a reason to move off of ISE.

## Notes from The Field - File Access

Continuing on the theme like with the path cmdlets and environment variables, PowerShell Core knows how to handle file access across platforms. For most cases, use the builtin cmdlets for reading and write files as they will know the variances between OS. For high performance read/write scenarios, you'll have to drop down to native APIs, but for your typical input/output workloads the content cmdlets work fine.

However beware the differences in platform support of cmdlets like Get-ChildItem. You will get back filesystem objects, but they won't have paths you expect if you're used to Windows Paths. Also be careful of aliases, if you still have `ls` defined somewhere and a `ls -la` is used you'll have a bad time.

Lastly file encoding can burn you if you use encodings other than ASCII or UTF8. Some older editors use UTF16 or UTF8 with byte-order-mark or BOM encoding, which is unreadable by some linux utilities. Set-Content used to be an offender with this, as was set to UTF8 by default.

## Notes from The Field - cAse...